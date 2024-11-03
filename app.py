from fastapi import FastAPI, HTTPException, Response
from pydantic import BaseModel
import mapscript

app = FastAPI()

# Define a data model for the incoming GeoJSON data
class GeoJSONData(BaseModel):
    geojson: dict

@app.post("/render-map/")
async def render_map(data: GeoJSONData):
    try:
        # Initialize the MapServer map object
        map_obj = mapscript.mapObj()

        # Add your GeoJSON data as a layer
        layer = mapscript.layerObj(map_obj)
        layer.type = mapscript.MS_LAYER_POLYGON
        layer.connectiontype = mapscript.MS_OGR
        layer.connection = "GeoJSON"
        layer.data = str(data.geojson)  # Use the GeoJSON data directly

        # Set rendering options for the layer (e.g., color)
        class_obj = mapscript.classObj(layer)
        style = mapscript.styleObj(class_obj)
        style.color.setRGB(255, 0, 0)  # Red polygons, for example

        # Render the image to PNG
        img = map_obj.draw()
        img_buffer = img.getBytes()

        # Return the PNG image as a response
        return Response(content=img_buffer, media_type="image/png")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
