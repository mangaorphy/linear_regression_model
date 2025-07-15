#!/bin/bash
# build.sh

# Install Python and dependencies
pip install -r requirements.txt

# # Optional: Verify model files exist
# if [ ! -f "app/models/nitrogen_model.pkl" ]; then
#     echo "Error: Model file not found!"
#     exit 1
# fi