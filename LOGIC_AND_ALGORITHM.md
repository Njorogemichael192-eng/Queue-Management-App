# Queue Management App — Logic and Algorithms

## 1. Application Model

The application manages people waiting for service.

Each person has:

```text
id
name
queueNumber
status
createdAt
servedAt
```

Possible statuses:

```text
Waiting
Served
```

SQLite is the source of truth.

---

# 2. Add Person Algorithm

### Input

```text
name
```

### Process

1. Receive the name.
2. Remove leading/trailing whitespace.
3. Validate that the name is not empty.
4. Determine the next queue number.
5. Create a new person.
6. Set status to `Waiting`.
7. Set `createdAt` to the current timestamp.
8. Set `servedAt` to NULL.
9. Insert the person into SQLite.
10. Reload the queue and statistics.
11. Update the UI.

### Pseudocode

```text
ADD_PERSON(name)

name = trim(name)

IF name is empty
    show validation error
    STOP

nextQueueNumber = determineNextQueueNumber()

person = {
    name: name,
    queueNumber: nextQueueNumber,
    status: "Waiting",
    createdAt: currentTime,
    servedAt: NULL
}

insert person into database

refresh UI
```

---

# 3. Queue Number Algorithm

Queue numbers are sequential.

First person:

```text
001
```

Second:

```text
002
```

Third:

```text
003
```

The number is stored as an integer in SQLite.

The UI formats it as three digits.

Example:

```text
1   → 001
9   → 009
10  → 010
25  → 025
100 → 100
```

The application should determine the next queue number using the highest existing queue number and increment it.

If there are no records:

```text
nextQueueNumber = 1
```

If the highest existing number is:

```text
15
```

then:

```text
nextQueueNumber = 16
```

Queue numbers should not be reused simply because an old person was deleted.

---

# 4. Waiting Queue Algorithm

Retrieve people where:

```text
status = "Waiting"
```

Sort by:

```text
queueNumber ASC
```

This ensures the person with the earliest queue number appears first.

Example:

```text
001 Michael
002 John
003 Brian
```

---

# 5. Next Person Algorithm

The NEXT PERSON operation follows FIFO:

**First In, First Out.**

### Process

1. Find the first waiting person.
2. If none exists, show "No people waiting."
3. Otherwise:

   * Change status from `Waiting` to `Served`.
   * Set `servedAt` to the current timestamp.
4. Save the update to SQLite.
5. Reload the queue.
6. Recalculate statistics.
7. Update the UI.

### Pseudocode

```text
SERVE_NEXT()

person = find first person
         WHERE status = "Waiting"
         ORDER BY queueNumber ASC

IF person does not exist
    show "No people waiting"
    STOP

UPDATE person
    status = "Served"
    servedAt = currentTime

refresh UI
```

---

# 6. Now Serving Algorithm

The "Now Serving" section should display the most recently served person.

Query:

```text
status = "Served"
ORDER BY servedAt DESC
LIMIT 1
```

If no served person exists:

```text
No one served yet
```

---

# 7. Delete Served People Algorithm

The DELETE SERVED operation removes only records with:

```text
status = "Served"
```

It must never remove people whose status is:

```text
Waiting
```

### Process

```text
User presses DELETE SERVED

IF no served people exist
    show "No served people to delete"
    STOP

show confirmation dialog

IF user confirms
    DELETE records WHERE status = "Served"
    refresh UI
ELSE
    cancel
```

---

# 8. Statistics Algorithm

Let:

```text
served = number of records where status = "Served"

waiting = number of records where status = "Waiting"

total = served + waiting
```

Therefore:

```text
total = number of all records
```

### Served Percentage

```text
IF total == 0
    servedPercentage = 0
ELSE
    servedPercentage = (served / total) × 100
```

### Waiting Percentage

```text
IF total == 0
    waitingPercentage = 0
ELSE
    waitingPercentage = (waiting / total) × 100
```

Example:

```text
Total = 20
Served = 4
Waiting = 16
```

Calculation:

```text
Served percentage
= (4 / 20) × 100
= 20%

Waiting percentage
= (16 / 20) × 100
= 80%
```

The percentages should always add up to approximately:

```text
100%
```

when the total is greater than zero.

---

# 9. Statistics After Add

Before:

```text
Total = 10
Served = 3
Waiting = 7
```

Add one person.

After:

```text
Total = 11
Served = 3
Waiting = 8
```

Percentages are recalculated automatically.

---

# 10. Statistics After Serving

Before:

```text
Total = 10
Served = 3
Waiting = 7
```

Serve one person.

After:

```text
Total = 10
Served = 4
Waiting = 6
```

The total remains unchanged because the person still exists in the database.

Only their status changes.

---

# 11. Statistics After Deleting Served

Before:

```text
Total = 10
Served = 4
Waiting = 6
```

Delete served people.

After:

```text
Total = 6
Served = 0
Waiting = 6
```

This is expected because the served records have been permanently removed.

---

# 12. Database State Flow

A person follows this basic lifecycle:

```text
              ADD
               │
               ▼
           ┌─────────┐
           │ WAITING │
           └────┬────┘
                │
          NEXT PERSON
                │
                ▼
           ┌────────┐
           │ SERVED │
           └────┬───┘
                │
        DELETE SERVED
                │
                ▼
             REMOVED
```

There should be no other states.

---

# 13. Persistence Algorithm

SQLite must preserve records when the application closes.

When the application starts:

```text
START APP
   ↓
Initialize SQLite
   ↓
Load existing records
   ↓
Calculate statistics
   ↓
Display queue
```

The application must not reset the database when restarted.

---

# 14. UI Refresh Algorithm

After every mutation:

```text
ADD
SERVE
DELETE
```

perform:

```text
Database operation
       ↓
Reload records
       ↓
Reload statistics
       ↓
Reload Now Serving
       ↓
Update UI
```

This prevents stale information from being displayed.

---

# 15. Edge Cases

## No People

Display:

```text
No people in the queue
```

Statistics:

```text
Total: 0
Served: 0%
Waiting: 0%
```

---

## No Waiting People

When NEXT PERSON is pressed:

```text
No people waiting.
```

Do not crash.

---

## No Served People

When DELETE SERVED is pressed:

```text
No served people to delete.
```

Do not crash.

---

## Empty Name

Do not insert the record.

Show:

```text
Please enter a name.
```

---

# 16. Core Invariants

The application must always maintain these rules:

```text
total = served + waiting
```

Every person must have exactly one valid status:

```text
Waiting OR Served
```

A person can only be served if currently:

```text
Waiting
```

Deleting served people must never delete waiting people.

The queue is always processed in ascending queue-number order.

Percentages are calculated from the current database state.

SQLite remains the source of truth.
