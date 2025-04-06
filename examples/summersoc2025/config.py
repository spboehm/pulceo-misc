#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
from dotenv import load_dotenv
scheme = os.getenv("PULCEO_API_SCHEME", "http")
host = os.getenv("PULCEO_API_HOST", "localhost")
psm_port = os.getenv("PULCEO_API_PSM_PORT", "7979")
prm_port = os.getenv("PULCEO_API_PRM_PORT", "7878")
# TODO: pms_port