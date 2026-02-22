from mcp.server.fastmcp import FastMCP
from pydantic import BaseModel, Field
import sys
import os

# Import custom modules (Defined below)
from modules.resolve_wrapper import ResolveController
from modules.blender_launcher import BlenderRender
from modules.brain_engine import CognitiveEngine

# Initialize the MCP Server
mcp = FastMCP("AutoStream-Studio")

# Initialize Sub-systems
brain = CognitiveEngine(db_path="./brain/memory.db")
resolve = ResolveController()
blender = BlenderRender()

class VideoRequest(BaseModel):
    topic: str = Field(description="Main topic of the video")
    language: str = Field(default="fa")

@mcp.tool()
def generate_educational_video(request: VideoRequest) -> str:
    """
    Orchestrates the full CLIL video production pipeline.
    """
    print(f"🚀 Launching pipeline for: {request.topic}")

    # Step 1: Cognitive Analysis (RAG + Leitner)
    # Check what user needs to review and fetch knowledge
    script_data = brain.generate_script_context(request.topic)
    forced_concepts = script_data['review_concepts']
    print(f"🧠 Injecting spaced repetition concepts: {forced_concepts}")

    # Step 2: Asset Generation (Blender)
    # Generate a dynamic 3D logo based on the topic mood
    logo_path = blender.render_dynamic_logo(
        text="YourBrandName", 
        color_theme=script_data['sentiment']
    )
    
    # Step 3: Assembly (DaVinci Resolve)
    if not resolve.connect():
        return "❌ Error: Could not connect to DaVinci Resolve. Is it open?"

    project_name = f"Auto_{request.topic.replace(' ', '_')}"
    timeline = resolve.create_project(project_name)
    
    # Import Assets
    resolve.import_media([logo_path, script_data['audio_path']])
    
    # Add Watermark (Logo Morph Strategy)
    resolve.add_watermark_effect(logo_path)

    # Step 4: Render
    output_file = resolve.start_render(f"C:/Outputs/{project_name}.mp4")
    
    # Step 5: Update Memory (Leitner)
    brain.update_leitner_box(forced_concepts, success=True)

    return f"✅ Video ready at {output_file}"

if __name__ == "__main__":
    mcp.run()