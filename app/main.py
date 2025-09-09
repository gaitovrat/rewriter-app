from fastapi import FastAPI
from openai import AsyncAzureOpenAI
from .configuration import AZURE_API_ENDPOINT, AZURE_API_KEY, AZURE_API_VERSION, AZURE_DEPLOYMENT
from .models import Message

app = FastAPI()
client = AsyncAzureOpenAI(
    api_version=AZURE_API_VERSION,
    azure_endpoint=AZURE_API_ENDPOINT,
    azure_ad_token=AZURE_API_KEY,
)

@app.post("/")
async def generate(message: Message):
    response = await client.chat.completions.create(
        messages=[
            {
                "role": "system",
                "content": "You are an assistant that helps people rewrite text in a more formal tone. Answer only with the rewritten text and nothing else. Answer in the same language as the input.",
            },
            {
                "role": "user",
                "content": message.content
            }
        ],
        max_tokens=4096,
        temperature=1.0,
        top_p=1.0,
        model=AZURE_DEPLOYMENT,
    )

    return {"response": response.choices[0].message.content}
