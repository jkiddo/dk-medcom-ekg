# dk-medcom-ekg
Implementation Guide for the MedCom EKG FHIR standard

## Verification

The **Verify numerical ECG examples** GitHub Actions workflow runs on branch
pushes and pull requests, and can also be started manually. It uses Node.js 24,
SUSHI 3.20.0, and Python 3.12 to compile the profiles and examples, then verify
the numerical recordings:

```sh
npm install --global fsh-sushi@3.20.0
sushi build --snapshot .
python3 scripts/check-numerical-examples.py
```

The Python check uses only the standard library. It checks the twelve-lead and
three-lead examples for sample counts, lead codes, amplitude scaling, recording
timing, derived limb relationships, matching embedded PDF bytes, and document
Bundle references. It also checks that the original PDF-only example remains
without numerical components.

Compilation or verification failures fail the workflow. Generated FHIR resources
and logs are uploaded as the `numerical-ecg-verification` artifact for 14 days,
including available output from failed runs. This workflow checks the committed
examples; it does not regenerate them or replace full FHIR instance validation.
