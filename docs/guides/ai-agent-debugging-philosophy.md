# AI Agent Debugging Philosophy

This guide captures key learnings and best practices for AI agents when debugging complex software issues. It is based on a real-world case study of a multi-layered bug in the Shifts application (Issue #12).

## Core Principles

1.  **Trust Your Analysis:** When you have systematically traced a problem to its root cause, have the confidence to implement the solution you've identified. Doubting a correct analysis is a common pitfall.
2.  **Systematic Hypothesis Testing:** Follow a structured approach. Form a hypothesis, test it, and document the result. If the hypothesis is wrong, form a new one based on what you've learned. This is not failure; it is progress.
3.  **Look for Secondary Bugs:** It is common for a primary bug to be masked by one or more secondary bugs. Fixing these is necessary progress, even if it doesn't immediately solve the main issue. In the case of Issue #12, a timezone error and a data loading order flaw were both real bugs that needed fixing.
4.  **Trace the Full Data Lifecycle:** Do not make assumptions about where data is being corrupted. Trace it from its point of creation to its final point of use (e.g., from `scheduleGenerator.js` to `storageService` to `main.js` to the UI).
5.  **Implement the Simplest Fix:** Once the root cause is found, implement the most direct and simple fix to verify it. In the case of Issue #12, the fix was a small, intelligent merge loop, not a complex library or refactor.

## Best Practices for Visual Analysis

When programmatic verification is insufficient, visual analysis of a UI screenshot can be used. However, this is prone to error if not done correctly.

1.  **Do Not Assume:** Never assume a successful screenshot command means the content is correct. The screenshot might be blank, show an error state, or be visually wrong.
2.  **Use Multimodal Analysis:** Use a tool like `gemini.py analyze` to programmatically analyze the content of the screenshot.
3.  **Construct a Specific, Context-Rich Prompt:** Do not ask simple, open-ended questions. Provide detailed context to guide the vision model.

    *   **Bad Prompt:** `"What's in this image?"` (Leads to hallucination)
    *   **Good Prompt:** `"This is a screenshot of a web application's user interface. The application is a shift scheduling tool. Focus your analysis on the grid for the project named 'Project Kaamanen'. Specifically, look at the rows for employees 'Niina' and 'Emilia'. Are there colored cells containing the letter 'W' in these two rows? Answer only with YES or NO."`

This method provides a much higher degree of confidence than a flawed assumption.

## A Case Study: The Shifts App Scheduling Bug (Issue #12)

This issue provides a perfect example of the debugging process.

-   **Symptom:** A generated schedule was not appearing in the UI.
-   **Hypothesis 1 (Incorrect):** The schedule generation algorithm was flawed.
    -   *Action:* Wrote unit tests.
    -   *Result:* The algorithm was correct.
-   **Hypothesis 2 (Partially Correct):** Date/timezone calculations were incorrect.
    -   *Action:* Corrected date logic to use UTC.
    -   *Result:* Fixed a real but secondary bug. The main symptom persisted.
-   **Hypothesis 3 (Partially Correct):** The data loading order was wrong.
    -   *Action:* Refactored `main.js` to load the generated schedule before saved data.
    -   *Result:* Fixed a real architectural flaw. The main symptom persisted.
-   **Hypothesis 4 (Root Cause):** A shallow data merge was overwriting good data.
    -   *Analysis:* An empty array (`[]`) from a saved file was overwriting the correctly generated schedule array.
    -   **Correct Solution:** Implement an intelligent merge that only overwrites the base data if the new data is valid and non-empty.

## Practical Steps for Gemini

1.  When you believe you have found the root cause, state it clearly.
2.  Propose the specific, minimal code change required to fix it.
3.  **Proceed with implementing that change.** Do not stop at the analysis phase.
4.  Verify the fix with a direct test (e.g., running the app and taking a screenshot).
5.  If the fix works, commit it with a clear message that explains the root cause and the solution.
