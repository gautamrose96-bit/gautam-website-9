import os
from crewai import Agent, Task, Crew, LLM

api_key = os.environ.get("GROQ_API_KEY")
if not api_key:
    raise ValueError("Set GROQ_API_KEY environment variable before running agent.py")

llm = LLM(
    model="groq/llama-3.3-70b-versatile",
    api_key=api_key,
)

agent = Agent(
    role="Web Developer",
    goal="Gautam Rose website banao",
    backstory="Expert developer hoon",
    llm=llm,
    allow_delegation=False
)

task = Task(
    description="Gautam Rose Print King ke liye beautiful homepage banao",
    expected_output="Complete HTML code",
    agent=agent
)

crew = Crew(agents=[agent], tasks=[task])
result = crew.kickoff()

with open("new_index.html", "w") as f:
    f.write(str(result))

print("Done! new_index.html ready!")
