# Requirements Specification: Core Task Prioritisation Engine

## 1. Scope of the System

This document establishes the functional requirements for the core `Task` data models, CRUD lifecycles, and other stuff. 

## 2. Functional Requirements

### 2.1 Task Lifecycle

* REQ-TA-1: The user shall not need any account or authentication to be able to use the system.
* REQ-TA-2: The system shall allow the user to create text-based tasks.
* REQ-TA-3: A task _must_ contain: a title (1-255 characters).
* REQ-TA-4: A task _can_ contain: a topic referenced via tag, a description (character limit?).
* REQ-TA-5: When a task is created with unknown topic tag, the user may be asked whether to create a new topic or change to an existing one.

### 2.2 Topic Lifecycle

* REQ-TO-1: A topic _must_ contain a title (1-255 characters).
* REQ-TO-2: A topic _can_ contain a description and a color.

### 2.3 Dashboard Lifecycle and Business Rules

* REQ-DB-1: Each newly created task must belong to a topic. If none is supplied, it defaults to the _unnamed_ topic.
* REQ-DB-2: Closing a task shall automatically set the `completedAt` parameter with the current system UTC server time.
* REQ-DB-3: The system shall be able to display all open tasks in prioritised order for both: all and individual topics.
* REQ-DB-4: The primary method of clearing tasks and topics shall be archiving. Archiving a topic will close all its associated tasks. The _unnamed_ topic _cannot_ be archived.
* REQ-DB-5: The application will generate a recommendation for each task on how to tackle it. 

### 2.4 Prioritisation

* REQ-PR-1: The priority metric shall take into account task importance and urgency.
* REQ-PR-2: Heuristics (TO BE REFINED)
  * REQ-PR-2.1: old tasks should be finished at some point       => importance increases with task age
  * REQ-PR-2.2: deadlines create growing urgency                 => urgency increases as due date approaches
  * REQ-PR-2.3: repeated re-scheduling may indicate unimportance => importance decreases with re-scheduling
* REQ-PR-3: Task importance should result from the user-defined importance score and REQ-PR-2.1 derived dynamic importance
* REQ-PR-3: Task urgency should result from the REQ-PR-2.2 derived dynamic urgency
* REQ-PR-4: The priority calculation for a task is independent from other tasks. They can be compared but do not influence each other.

### 2.5 Recommendation

* REQ-PR-1: The recommendation for a task is derived from the Eisenhower Matrix and the task importance and urgency.
* REQ-PR-2: As task importance and urgency changes over time, the recommendation is expected change to as well.

## 3. Non-Functional Requirements

### 3.1 External Interface & System Integrations

### 3.2 Quality of Service & Compliance

### 3.3 Performance

### 3.4 Security

## 4. Open Questions

* Should the system distinguish between `done` and `cancelled` (both are just `closed` right now)?
* Terminology: (Important, Urgency) or (Impact, Effort)?
