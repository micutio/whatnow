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
* REQ-DB-2: Closing a task shall automatically populate the `completed_at` timestamp parameter with the current system UTC server time.
* REQ-DB-3: The system shall be able to display all open tasks in prioritised order for both, all topics together and individual topics.

### 2.4 Prioritisation

* REQ-PR-1: The priority metric shall take into account:
  * importance score (or alternatively called: _impactfulness_)
  * time elapsed since creation (long pending tasks should be closed eventually, either by completing or discarding).
  * due date

## 3. Non-Functional Requirements

### 3.1 External Interface & System Integrations

### 3.2 Quality of Service & Compliance

### 3.3 Performance

### 3.4 Security

## 4. Open Questions

* Should the system distinguish between `done` and `cancelled` (both are just `closed` right now)?
