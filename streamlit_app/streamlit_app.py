import streamlit as st
import pandas as pd
from surprise.dataset import Reader, Dataset
from surprise import SVD 
import pydeck as pdk

# Define available destinations per attempt level
st.set_page_config(layout="wide")
def load_existing_data():
    # Replace this path with your data file path, using a sample for demonstration
    existing_data = pd.read_csv('preprocessed.csv')
    existing_data2 = pd.read_csv('area_xy.csv')

    return existing_data, existing_data2

preprocessed, area_coord_f = load_existing_data()

destinations_options = area_coord_f.groupby('SIDO')['VISIT_AREA_NM'].apply(list).to_dict()

# Define a function to add data
def add_data():
   new_entry = {
        "시도": st.session_state.sido,
        "방문지": st.session_state.visit_area,
        "평점": st.session_state.rating
    }
   st.session_state.inputdata.append(new_entry)

def clear_data():
    """Function to clear all input data from the session state."""
    st.session_state.inputdata.clear()
    combined_df = preprocessed.copy()

def recomend_visit_area(combined_df):
   reader = Reader(line_format='user item rating timestamp', sep='\t', rating_scale= (1,5))
   data = Dataset.load_from_df(combined_df[['userID', 'itemID', 'rating']], reader)
   train_set = data.build_full_trainset()
   rcsys = SVD(n_factors=20, n_epochs=20, random_state=9999)
   rcsys.fit(train_set)
   pred = [rcsys.predict('testID', area_nm) for area_nm in combined_df.itemID.unique() if area_nm not in combined_df.query('userID=="testID"').itemID.values]
   pred.sort(key = lambda x: x.est, reverse = True)
   return pred

# Initialize session state for storing input data if not already present
if "inputdata" not in st.session_state:
    st.session_state.inputdata = []

if "recdata" not in st.session_state:
    st.session_state.recdata = []

# Left column for input fields
left_col, right_col = st.columns([0.3, 0.7])
#  displaying the table
with left_col:

    st.header("입력")
    attempt_selected = st.selectbox("시도", options=list(destinations_options.keys()), key="sido")
    st.number_input("평점", min_value=1, max_value=5, key="rating")
    # Update Visit Destination options based on Attempt selection
    destination_selected = st.selectbox(
        "방문지", options=destinations_options[attempt_selected], key="visit_area"
    )
    
    # Button to add data to the table
    if st.button("Add to Table"):
        add_data()
        st.success("Entry added!")

    st.header("평점 기록")
    if st.session_state.inputdata:
        # Create a DataFrame from the data list in session state
        df = pd.DataFrame(st.session_state.inputdata)
        combined_df = pd.concat([preprocessed, df\
                                .rename(columns = {'시도':'SIDO', '방문지':'itemID'})\
                                .assign(userID='testID').reindex(columns = ['userID', 'itemID', 'rating'])], ignore_index=True)\
                                    .reset_index(drop=True)

        st.dataframe(df)
        # Button to clear the table
        if st.button("Clear All Data"):
            clear_data()
            st.success("All data cleared.")
    else:
        st.write("No data available yet.")

with right_col:
    st.header("추천지")
    if st.button("Recommend"):
        pred = recomend_visit_area(combined_df)
        # Create a DataFrame from the data list in session state
        pred_df = pd.DataFrame(pred).head(3).merge(area_coord_f, how='left', left_on='iid', right_on='VISIT_AREA_NM')\
            .filter(regex='VISIT_AREA_NM|COOR|SIDO').rename(columns = {'Y_COORD':'lat', 'X_COORD':'lon'})
        # st.dataframe(pred_df)
        # st.map(pred_df)
        # Define Pydeck Layer
        layer = pdk.Layer(
            "ScatterplotLayer",
            data=pred_df,
            get_position="[lon, lat]",
            get_radius=70,
            get_color=[200, 30, 0, 160],
            pickable=True  # Enables the hover tooltip functionality
        )

        # Set up the deck.gl map view
        view_state = pdk.ViewState(
            latitude=pred_df["lat"].mean(),
            longitude=pred_df["lon"].mean(),
            zoom=13,
            pitch=0
        )

        # Render the deck.gl map
        st.pydeck_chart(pdk.Deck(
            layers=[layer],
            initial_view_state=view_state,
            map_style="mapbox://styles/mapbox/streets-v11",
            tooltip={"text": "{VISIT_AREA_NM}"}  # Defines the tooltip content
        ))
    else:
        st.write("No data available yet.")

