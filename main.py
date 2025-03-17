import spacy
import json

from typing import Union
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
  CORSMiddleware,
  allow_origins=["*"],
  allow_credentials=True,
  allow_methods=["*"],
  allow_headers=["*"],
)

nlp = spacy.load("en_core_web_sm")

@app.post("/api/tokenizer/{text}")
def tokenizeText(text: str):
  doc = nlp(text)

  dependency_data = {
      "sentence": doc.text,
      "tokens": []
  }

  for token in doc:
      dependency_data["tokens"].append({
          "index": token.i,
          "text": token.text,
          "pos": token.pos_,
          "dep": token.dep_,
          "head": token.head.i if token.head != token else None,  # ROOTの場合はnull
          "children": [child.i for child in token.children]
      })

  json_output = json.dumps(dependency_data, indent=2)
  return dependency_data
