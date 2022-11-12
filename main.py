import json
import os
import sys

import dotenv
from flask import Flask, request

dotenv.load_dotenv(".env.dev")

FIELD = "logging.googleapis.com/trace"

GOOGLE_CLOUD_PROJECT = os.environ["GOOGLE_CLOUD_PROJECT"]


app = Flask("structured-logging-gcp")


def log_info():
    trace = get_trace_id()
    log = {
        "severity": "INFO",
        FIELD: trace,
        "message": "This is an info message",
    }
    json.dump(log, sys.stdout)
    sys.stdout.write("\n")


@app.route("/")
def index():
    return "Hello, World"


@app.route("/trace")
def trace():
    log_info()

    trace = get_trace_id()
    log = {
        "severity": "ERROR",
        FIELD: trace,
        "message": "This is an intended error message :)",
    }
    json.dump(log, sys.stdout)
    sys.stdout.write("\n")

    return "done"


def get_trace_id():
    if trace_header := request.headers.get("X-Cloud-Trace-Context"):
        trace_id, _ = trace_header.split("/", maxsplit=1)
        return f"projects/{GOOGLE_CLOUD_PROJECT}/traces/{trace_id}"

    return None
