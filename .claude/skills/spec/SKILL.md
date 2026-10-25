---
name: spec
description: |
  Turn a vague feature idea or client request into a precise spec in notes/specs/<slug>.md: problem, users,
  Given/When/Then acceptance criteria, out of scope, open questions, decisions log. Interview mode, five phases max.
  TRIGGERS: "/spec", "write a spec", "spec this", "turn this into requirements", "what should we build for".
---

# Spec: from intent to acceptance criteria

Rules: `.claude/rules/requirements.md`. Output: `notes/specs/<slug>.md`. Never writes outside `notes/`.

## Phases (stop after each, ask, continue on their answer)

1. **Frame.** Restate the request in two sentences and list what you think you know vs. what you are guessing
   (said / inferred / open). Ask the 3 to 5 questions whose answers change the design most. Not more.
2. **Users and flow.** Who uses it, from where, how often. The happy path as 5 to 10 numbered steps. One
   question per fork in the path you cannot resolve.
3. **Criteria.** Given / When / Then, one observable outcome each, including the edge cases from the rules
   file. Mark each criterion `said` or `inferred`. Ask them to strike or confirm the inferred ones.
4. **Boundaries.** Out of scope (explicit), dependencies, risks, and anything that needs a decision from the
   client (owner · question · what answer unblocks it).
5. **Write.** Save the file with these sections: Problem · Users · Flow · Acceptance criteria · Out of scope ·
   Open questions · Decisions (date · decision · by whom) · Source (meeting note or message that started it).
   Then say the path and the count of open questions.

## Shape rules
- If a relevant project is mapped in `notes/projects/`, read it first; cite existing behaviour the spec touches.
- A spec with zero open questions on the first pass is suspicious; say so.
- Skip phases they already answered; never re-ask what is written in the source note.
- When they say "just write it", write it with every inference labelled and the questions listed. Do not block.
