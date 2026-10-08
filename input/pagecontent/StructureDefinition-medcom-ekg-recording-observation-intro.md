# MedCom EKG Recording Observation
This page describes how the **MedCom Ekg Recording Observation** profile is intended to be used within the MedCom EKG Recording standard.

## Purpose of the Profile
This profile specifies how the Observation represents the PDF-encoded EKG recording using a dedicated extension. It also specifies how the related attachment metadata, acquisition note, and timing information must be captured, and how the required LOINC coding and references to the patient and performing organization must be applied. Read more about this in the following paragrafs.

### Use of the valueAttachment Extension
This Observation contains a FHIR extension designed to hold an EKG recording as a PDF file encoded in Base64. The `valueAttachment` element is implemented as an extension because the base `value[x]` element does not support the `Attachment` type in FHIR R4. The extension also captures essential metadata for the attachment - the MIME type and the title.

### Optional numerical ECG waveforms

The PDF attachment remains mandatory. Producers MAY additionally supply the sampled
signals in `Observation.component`, with one component per lead. Existing PDF-only
recordings remain valid. Numerical samples are optional to produce and consume;
receivers must still support the PDF. This addition does not assert conformance to
the PoCD or PHD implementation guides.

Each component identifies a standard lead using an IEEE 11073 MDC code from the
[ECG lead value set](ValueSet-medcom-ekg-lead-valueset.html) and contains one
`valueSampledData`. A producer may supply a subset of the twelve leads; a missing
component means that lead is not supplied numerically, not that its voltage is zero.
This representation covers one synchronized, regularly sampled segment. Separate
segments or asynchronous leads must not be concatenated into the same arrays.

| Element | Meaning |
| --- | --- |
| `component.code` | Lead I, II, III, aVR, aVL, aVF, or V1 through V6, coded in `urn:iso:std:iso:11073:10101`. Each lead may appear only once. |
| `valueSampledData.origin` | Amplitude offset, with UCUM system `http://unitsofmeasure.org` and unit code `mV`. |
| `valueSampledData.factor` | Multiplier applied to each stored sample; defaults to 1 if absent. |
| `valueSampledData.period` | Positive interval between samples, in milliseconds. All leads use the same interval. |
| `valueSampledData.dimensions` | Fixed to 1: one scalar per sample in this lead. |
| `valueSampledData.data` | Complete, space-separated sequence of samples in acquisition order. |

Decode each amplitude as `origin.value + factor * sample`, in millivolts. For
example, with origin 0 and factor 0.001, the stored value `1100` means 1.1 mV.
FHIR R4 also permits `E`, `L`, and `U` for missing or out-of-range samples; these
are not numeric amplitudes and must not be plotted as zero. `L` and `U` require
the corresponding lower or upper limit. Sample positions must be preserved.

When samples are included, `effectivePeriod.start` and `effectivePeriod.end` are
required. The start is the time of the first sample for every lead. All arrays
SHALL have equal sample counts. For N samples separated by interval P, the last
sample occurs at `start + (N - 1) * P`; the period end SHALL be `start + N * P`.
This half-open interval convention is specific to this profile. Equal sample
counts and period coverage require application-level checks in addition to the
FHIR profile invariants.

The PDF and the numerical samples SHALL describe the same recording and subject.
Producers SHALL preserve the acquisition timing, scaling, and lead identities;
the optional arrays are not a substitute for the required PDF. The source FHIR
profiles do not by themselves verify that PDF curves agree with sample values.

#### Relationship to PoCD and PHD

The lead-component layout follows the pattern used by the
[PoCD ECG sample-array example](https://hl7.org/fhir/uv/pocd/Observation-ECGSampleArrayObservation.html).
The [PHD consumer guidance](https://hl7.org/fhir/uv/phd/en/ProfileConsumers.html#periodic-measurements)
uses the same SampledData decoding model. Its standalone RTSA profile places a
signal in `Observation.valueSampledData`; its compound model also allows sampled
signals in `Observation.component.valueSampledData`.

This MedCom profile remains a document Observation coded as LOINC `11524-6`.
It does not require PHD category, source device, gateway, or clock-correlation
metadata and must not be declared as a PHD or PoCD profile solely because it
contains samples. Converting a device observation must preserve such provenance
separately when needed. In FHIR R4 the scaling field is named `factor`, even where
the PHD narrative refers to it as `scaleFactor`.

### EKG Recording note
This Observation includes a free-text note related to the EKG acquisition, intended for documenting brief, measurement-related remarks. To ensure consistency and concise usage, the note is limited to a maximum length of 1024 characters and allows line breaks.

#### Line breaks and special characters in the note
Implementations must preserve the logical value, including line breaks and Unicode characters, across both XML and JSON. The note element **MUST** follow:

- In JSON, line breaks **SHALL** be written as the escaped newline sequence `\n`. The special character `"` **MUST** be escaped with `\"` when used inside the note.
- In XML, line breaks **SHALL** be represented as the character reference `&#xA;`. Escaping of characters in XML **SHALL** preserve the logical value. XML-reserved characters `&`, `<`, `>`, `'` and `"` **SHALL** be escaped.

Unicode characters (e.g. ÆØÅ, ë, ð, ý) **SHALL** be supported without restriction in both XML and JSON as document consumer system and **SHOULD** be supported without restriction in both XML and JSON as document source system.

### EKG Recording date and time
The `effective[x]` element is a mandatory element used to represent the timing of the EKG recording and **SHALL** be provided either as a period or alternatively as a dateTime.

- `effectivePeriod.start` – Represents the exact start time of the EKG recording and is required if known.
- `effectivePeriod.end` – Represents the exact end time of the EKG recording and is required if known in combination with `effectivePeriod.start`.
- `effectiveDateTime` – Used only when the exact start time is unknown.

## Required LOINC coding
This Observation contains the fixed code:

- code.coding:LOINC: code: `11524-6` system: `http://loinc.org` display: `EKG study`.

## Resource references
This Observation references the `Patient` resource through the `subject` element and the author `Organization` through the `performer` element.
