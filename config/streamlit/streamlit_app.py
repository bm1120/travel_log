import streamlit as st
import pandas as pd
from surprise.dataset import Reader, Dataset
from surprise import SVD 

# Define available destinations per attempt level
@st.cache
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
   st.session_state.data.append(new_entry)

def recomend_visit_area(combined_df):
   reader = Reader(line_format='user item rating timestamp', sep='\t', rating_scale= (1,5))
   data = Dataset.load_from_df(combined_df[['userID', 'itemID', 'rating']], reader)
   train_set = data.build_full_trainset()
   rcsys = SVD(n_factors=10, n_epochs=20, random_state=9999)
   rcsys.fit(train_set)
   pred = [rcsys.predict('testID', area_nm) for area_nm in combined_df.itemID.unique() if area_nm not in combined_df.query('userID==@test_id').itemID.values]
   pred.sort(key = lambda x: x.est, reverse = True)
   return pred

# Set up the dashboard layout with two columns
col1, col2, col3 = st.columns(3)

# Initialize session state for storing input data if not already present
if "inputdata" not in st.session_state:
    st.session_state.data = []

if "recdata" not in st.session_state:
    st.session_state.recdata = []

# Left column for input fields
with col1:
    st.header("Input Data")
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

# Right column for displaying the table
with col2:
    st.header("Dashboard Table")
    if st.session_state.inputdata:
        # Create a DataFrame from the data list in session state
        df = pd.DataFrame(st.session_state.data)
        combined_df = pd.concat([preprocessed, df\
                                 .rename(columns = {'시도':'SIDO', '방문지':'itemID'})\
                                 .assign(userID='testID').reindex(columns = ['userID', 'itemID', 'rating'])], ignore_index=True)\
                                    .reset_index(drop=True)

        st.dataframe(df)
    else:
        st.write("No data available yet.")

with col3:
    st.hader("Dashboard Table")
    if st.button("Recommend"):
      if st.session_state.recdata:
         pred = recomend_visit_area(combined_df)
         # Create a DataFrame from the data list in session state
         st.dataframe(pd.DataFrame(pred))
      else:
         st.write("No data available yet.")

