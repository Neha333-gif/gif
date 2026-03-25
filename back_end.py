from fastapi import FastAPI 
from pydantic import BaseModel 
import requests 
from groq import Groq

import os

api_key = os.getenv("GROQ_API_KEY")
client = Groq(api_key=api_key)

from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)



#----Models----------

class TopicRequest(BaseModel):
    topic : str 

class SearchRequest(BaseModel):
    query : str 



# generate quotes 

@app.post("/generate")
def generate_quotes(data : TopicRequest):
    try:
        response = client.chat.completions.create(
            model = "llama-3.1-8b-instant",
            messages = [
                {"role" : "user",
                "content" : f"""Generate 3 short quotes about {data.topic} in a list in the form 
                1. quote1 
                
                2. quote2
                
                3. quote3

                              
                tips - avoid "" and "\" and "," and give 2 lines space betwen two consecutive quotes
                keep it neat looking
                """}
            ]
        )
        
        text = response.choices[0].message.content

        quotes = [q.strip().lstrip("- ") for q in text.split("\n") if q.strip()]
        return {"quotes" : quotes}

    except Exception as e:
        return {"error" : str(e)}

    

    # search quotes 


# @app.post("/search")
# def search_quotes(data: SearchRequest):
#     try:
#         res = requests.get(f"https://api.quotable.io/search/quotes?query={data.query}")
#         api_data = res.json()

#         print("STATUS:", res.status_code)
#         print("RAW:", res.text)

#         api_data = res.json()
#         quotes = [item["content"] for item in api_data.get("results", [])]
#         return {"quotes" : quotes}
#     except Exception as e:
#         return {"error" : str(e)}
    

@app.get("/")
def home():
    return {"message" : "quote app is running"}
        



