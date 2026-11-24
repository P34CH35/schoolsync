from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="SchoolSync Backend")

# Let Flutter talk to Python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# FAKE DATABASE - Bayview High
# Later we will replace this with a real database
MARKS = [
    {"subject": "Mathematics", "mark": "68%"},
    {"subject": "English", "mark": "74%"},
    {"subject": "Life Sciences", "mark": "81%"},
    {"subject": "CAT", "mark": "89%"},
]

TIMETABLE = [
    {"time": "08:00 - 09:00", "subject": "Mathematics", "room": "Room 4"},
    {"time": "09:00 - 10:00", "subject": "English", "room": "Room 2"},
    {"time": "10:30 - 11:30", "subject": "Life Sciences", "room": "Lab 1"},
    {"time": "11:30 - 12:30", "subject": "CAT", "room": "Computer Lab"},
]

@app.get("/")
def home():
    return {"message": "SchoolSync Backend is running for Bayview High"}

@app.get("/marks")
def get_marks():
    return MARKS

@app.get("/timetable")
def get_timetable():
    return TIMETABLE

@app.get("/homework")
def get_homework():
    return [
        {"subject": "Mathematics", "task": "Complete exercise 5.2 - Algebra", "due": "Tomorrow"},
        {"subject": "English", "task": "Read chapter 4 and write summary", "due": "Friday"},
        {"subject": "Life Sciences", "task": "Draw and label heart diagram", "due": "Monday"},
        {"subject": "History", "task": "Research Apartheid essay - 500 words", "due": "Next Week"},
    ]

@app.get("/attendance")
def get_attendance():
    return [
        {"subject": "Mathematics", "present": 18, "total": 20, "percentage": "90%"},
        {"subject": "English", "present": 19, "total": 20, "percentage": "95%"},
        {"subject": "Life Sciences", "present": 16, "total": 20, "percentage": "80%"},
        {"subject": "History", "present": 20, "total": 20, "percentage": "100%"},
        {"subject": "Geography", "present": 17, "total": 20, "percentage": "85%"},
    ]