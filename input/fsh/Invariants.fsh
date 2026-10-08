Invariant: medcom-datetime-has-time-offset-zulu
// This invariant allows both zulu and offset time zones.
//Winter time
//"2025-11-27T13:34:56+01:00"
//"2025-11-27T12:34:56.789Z"
//Summer time
//"2025-06-27T14:34:56+02:00"
//"2025-06-27T12:34:56.789Z"
Description: "dateTime must include date, time, and time zone."
Severity: #error
Expression: "$this.toString().matches('^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]([.][0-9]+)?(Z|[+-][0-9]{2}:[0-9]{2})$')"


Invariant: medcom-canonical-fixed-major
Description: "If a version is present in the canonical, MAJOR SHALL be a fixed value."
Severity: #error
Expression: "matches('^.*[|]2[.].*$')"

Invariant: medcom-ekg-positive-sample-period
Description: "The interval between ECG samples must be greater than zero milliseconds."
Severity: #error
Expression: "$this > 0"

Invariant: medcom-ekg-waveform-period
Description: "Numerical ECG waveforms require an effectivePeriod with a start and an end after the start."
Severity: #error
Expression: "component.empty() or (effective.ofType(Period).start.exists() and effective.ofType(Period).end.exists() and effective.ofType(Period).end > effective.ofType(Period).start)"

Invariant: medcom-ekg-unique-leads
Description: "Each numerical ECG lead may occur only once."
Severity: #error
Expression: "component.code.coding.code.isDistinct()"

Invariant: medcom-ekg-common-sample-period
Description: "All numerical ECG leads must have the same sampling interval."
Severity: #error
Expression: "component.value.ofType(SampledData).period.distinct().count() <= 1"
