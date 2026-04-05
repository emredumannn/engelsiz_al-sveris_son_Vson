from fastapi import APIRouter, UploadFile, File, HTTPException
from app.services.ai_service import AIService

router = APIRouter()

@router.post("/analyze")
async def analyze_image(file: UploadFile = File(...)):
    """
    Analyzes an uploaded image using the AI Service.
    Returns detected objects, text, and classification.
    """
    if not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="File must be an image.")

    try:
        contents = await file.read()
        result = AIService.process_image(contents)
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
