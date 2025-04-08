#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
from dotenv import load_dotenv

scheme = os.getenv("PULCEO_API_SCHEME", "http")
host = os.getenv("PULCEO_API_HOST", "localhost")
psm_port = os.getenv("PULCEO_API_PSM_PORT", "7979")
prm_port = os.getenv("PULCEO_API_PRM_PORT", "7878")
MQTT_SERVER_NAME = os.getenv("MQTT_SERVER_NAME", "localhost")
MQTT_PORT = os.getenv("MQTT_PORT", 1883)
MQTT_TLS = os.getenv("MQTT_TLS", "false")
MQTT_TLS_INSECURE = os.getenv("MQTT_TLS_INSECURE", "true")
MQTT_USERNAME = os.getenv("MQTT_USERNAME", "")
MQTT_PASSWORD = os.getenv("MQTT_PASSWORD", "")
LOCAL_SCHEDULING = os.getenv("LOCAL_SCHEDULING", True)