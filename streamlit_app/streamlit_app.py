import streamlit as st
import pandas as pd
from surprise.dataset import Reader, Dataset
from surprise import SVD
import folium
from streamlit_folium import st_folium

# Set Streamlit page configuration
st.set_page_config(layout="wide")

# Load existing data from files
def load_existing_data():
    existing_data = pd.read_csv('preprocessed.csv')
    existing_data2 = pd.read_csv('area_xy.csv')
    return existing_data, existing_data2

preprocessed, area_coord_f = load_existing_data()
destinations_options = area_coord_f.groupby('SIDO')['VISIT_AREA_NM'].apply(list).to_dict()

# Function to add data to session state
def add_data():
    new_entry = {
        "시도": st.session_state.sido,
        "방문지": st.session_state.visit_area,
        "평점": st.session_state.rating
    }
    st.session_state.inputdata.append(new_entry)

# Function to clear all input data
def clear_data():
    st.session_state.inputdata.clear()

# Recommendation function
def recomend_visit_area(combined_df):
    reader = Reader(line_format='user item rating timestamp', sep='\t', rating_scale=(1, 5))
    data = Dataset.load_from_df(combined_df[['userID', 'itemID', 'rating']], reader)
    train_set = data.build_full_trainset()
    rcsys = SVD(n_factors=20, n_epochs=20, random_state=9999)
    rcsys.fit(train_set)
    pred = [rcsys.predict('testID', area_nm) for area_nm in combined_df.itemID.unique() if area_nm not in combined_df.query('userID=="testID"').itemID.values]
    pred.sort(key=lambda x: x.est, reverse=True)
    return pred

# Initialize session state for storing input data and recommendation visibility
if "inputdata" not in st.session_state:
    st.session_state.inputdata = []
if "show_recommendation" not in st.session_state:
    st.session_state.show_recommendation = False

# Left column for input fields
left_col, right_col = st.columns([0.3, 0.7])

# Input form
with left_col:
    st.header("입력")
    attempt_selected = st.selectbox("시도", options=list(destinations_options.keys()), key="sido")
    st.number_input("평점", min_value=1, max_value=5, key="rating")
    
    # Update Visit Destination options based on Attempt selection
    destination_selected = st.selectbox("방문지", options=destinations_options[attempt_selected], key="visit_area")
    
    # Button to add data to the table
    if st.button("Add to Table"):
        add_data()
        st.success("Entry added!")

    # Display input data table
    st.header("평점 기록")
    if st.session_state.inputdata:
        df = pd.DataFrame(st.session_state.inputdata)
        combined_df = pd.concat([preprocessed, df.rename(columns={'시도': 'SIDO', '방문지': 'itemID', '평점': 'rating'}).assign(userID='testID').reindex(columns=['userID', 'itemID', 'rating'])], ignore_index=True).reset_index(drop=True)
        st.dataframe(df)

        # Button to clear all data
        if st.button("Clear All Data"):
            clear_data()
            st.success("All data cleared.")
    else:
        st.write("No data available yet.")

# Right column for recommendations and map
with right_col:
    st.header("추천지")

    # Check if Recommend button was clicked
    if st.button("Recommend"):
        st.session_state.show_recommendation = True
        pred = recomend_visit_area(combined_df)
        
        # Filter predictions and add coordinates
        sido_user = pd.DataFrame(st.session_state.inputdata)["시도"].values
        pred_df = (pd.DataFrame(pred)
                   .assign(est=lambda df: df.est.apply(lambda x: round(x, 1)))
                   .merge(area_coord_f, how='left', left_on='iid', right_on='VISIT_AREA_NM')
                   .filter(regex='VISIT_AREA_NM|COOR|SIDO|est')
                   .rename(columns={'Y_COORD': 'lat', 'X_COORD': 'lon'})
                   .query('SIDO in @sido_user')
                   .head(10)
                   .reset_index())

        # Store recommendation data in session state to keep visible
        st.session_state.pred_df = pred_df

    # Display recommendations if "Recommend" has been clicked
    if st.session_state.show_recommendation:
        pred_df = st.session_state.pred_df

        # Create a Folium map
        m = folium.Map(location=[pred_df["lat"].mean(), pred_df["lon"].mean()], zoom_start=10)

        # Add markers with clickable links
        for _, row in pred_df.iterrows():
            popup_html = (
                f"<b>{row['VISIT_AREA_NM']}</b><br>"
                f"예상평점: {row['est']}점<br>"
                f"<a href='https://maps.google.com/?q={row['lat']},{row['lon']}' target='_blank'>Google Maps</a><br>"
                f"<a href='https://www.google.com/maps/@?api=1&map_action=pano&viewpoint={row['lat']},{row['lon']}' target='_blank'>Google 로드뷰</a>"
            )

            popup = folium.Popup(popup_html, max_width=300, min_width=200)  # Set max and min width here
            folium.Marker(
                location=[row["lat"], row["lon"]],
                popup=popup,
                tooltip=row["VISIT_AREA_NM"]
            ).add_to(m)

        # Display the Folium map in Streamlit
        st_folium(m, width=700, height=500)
        
        # Display prediction DataFrame for reference
        st.dataframe(pred_df)
    else:
        st.write("No recommendations available yet. Click 'Recommend' to generate suggestions.")
