#!/bin/bash
# set -e  # die on first error

# 1. Create and enter a new clean environment
# conda create -n phystwin_clean python=3.10 -y
# conda activate phystwin_clean

# 2. Core packages
conda install -y numpy=1.26.4 opencv

# 3. Core torch install FIRST, pinned
conda install -y pytorch=2.4.0 torchvision=0.19.0 torchaudio=2.4.0 pytorch-cuda=12.1 -c pytorch -c nvidia

# 4. LOCK IT so pip can’t upgrade it
pip install "torch==2.4.0" --no-deps

# 5. Now install other pip packages — use --no-deps where needed to avoid breaking torch
pip install warp-lang
pip install usd-core matplotlib
pip install "pyglet<2"
pip install open3d
pip install trimesh
pip install rtree 
pip install pyrender
pip install stannum
pip install termcolor
pip install fvcore
pip install wandb
pip install moviepy imageio
pip install cma
pip install --no-index --no-cache-dir pytorch3d -f https://dl.fbaipublicfiles.com/pytorch3d/packaging/wheels/py310_cu121_pyt240/download.html

# Realsense camera packages
pip install Cython
pip install pyrealsense2
pip install atomics
pip install pynput

# Grounded SAM / GroundingDINO — these need --no-deps to avoid torch damage
pip install git+https://github.com/IDEA-Research/Grounded-SAM-2.git
pip install git+https://github.com/IDEA-Research/GroundingDINO.git

# SDXL + Diffusers — known to silently upgrade torch, so we slap it
pip install diffusers --no-deps
pip install accelerate --no-deps

# TRELLIS install
cd data_process
git clone --recurse-submodules https://github.com/microsoft/TRELLIS.git
cd TRELLIS
. ./setup.sh --basic --xformers --flash-attn --diffoctreerast --spconv --mipgaussian --kaolin --nvdiffrast
cd ../..

# Final 3D stuff
pip install gsplat
pip install kornia
cd gaussian_splatting/
pip install submodules/diff-gaussian-rasterization/
pip install submodules/simple-knn/
cd ..

# if gsplat doesn't work
# pip uninstall gsplat
# git clone https://github.com/nerfstudio-project/gsplat.git
# cd gsplat
# rm -rf build/ gsplat.egg-info/ dist/
# git submodule update --init --recursive
# pip install .
# cd ..