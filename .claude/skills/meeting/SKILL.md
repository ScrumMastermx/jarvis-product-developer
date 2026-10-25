---
name: meeting
description: |
  Turn raw meeting notes or a transcript (client or team) into a structured note in notes/meetings/YYYY-MM-DD-<slug>.md:
  decisions, action items (owner · what · due), open questions, candidate requirements for /spec.
  TRIGGERS: "/meeting", "process these notes", "here is the transcript", "meeting notes", "what did we decide".
---

# Meeting: raw notes to decisions and actions

Input: pasted text, a file path, or a transcript. Output: `notes/meetings/YYYY-MM-DD-<slug>.md`.

## Steps
1. Read the whole input once. Identify participants, date (ask if missing), and the topic for the slug.
2. Extract, in this order:
   - **Decisions**: what was decided, by whom, with the sentence that shows it. No decision without a source line.
   - **Action items**: `owner · what · due`. Unassigned or undated items are listed as such, not guessed.
   - **Open questions**: asked but not answered, or answered ambiguously (quote both readings).
   - **Candidate requirements**: anything that sounds like "the system should..."; each one labelled `said`
     (quote) or `inferred` (your reading, "confirm or correct").
   - **Noise dropped**: one line saying what you filtered (small talk, repeats) so nothing silently vanishes.
3. Write the file: Participants · Summary (3 lines) · Decisions · Action items · Open questions · Candidate
   requirements · Dropped. Dates and names on every line that has them.
4. Reply with the path, the action items table, and the question count. Offer `/spec` for the candidate
   requirements. Do not start the spec unasked.

## Rules
- Participants' words are theirs. Never upgrade "maybe" to "decided".
- If the transcript is in another language, keep quotes in the original and write the structure in English.
- Never send, post or email the result anywhere. It lands in `notes/` only.
