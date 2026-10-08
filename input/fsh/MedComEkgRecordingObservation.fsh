Profile: MedComEkgRecordingObservation
Parent: MedComDocumentObservation
Id: medcom-ekg-recording-observation
Title: "MedComEkgRecordingObservation"
Description: "Observation profile intended to be used in MedCom's Ekg Recording standard."
* status = #final
* status ^short = "Status MUST be final." 
* effective[x] only dateTime or Period
* effective[x] 1..1 MS
* effective[x] ^short = "The time or time period of the EKG recording."
* effectiveDateTime MS
* effectiveDateTime ^short = "The time of the EKG recording. Use this if effectivePeriod.start is unknown."
* effectiveDateTime obeys medcom-datetime-has-time-offset-zulu
* effectivePeriod MS
* effectivePeriod.start 1..1 MS
* effectivePeriod.start obeys medcom-datetime-has-time-offset-zulu
* effectivePeriod.start ^short = "The start time of the EKG recording"
* effectivePeriod.end 0..1 MS
* effectivePeriod.end obeys medcom-datetime-has-time-offset-zulu
* effectivePeriod.end ^short = "The end time of the EKG recording"
* code.coding[LOINC] 1..1 MS
* code.coding[LOINC].code MS
* code.coding[LOINC].code = #11524-6 (exactly)
* code.coding[LOINC].display 1.. MS
* code.coding[LOINC].display = "EKG study" (exactly)
* code.coding[LOINC].system MS
* subject 1..1 MS
* subject only Reference(MedComDocumentPatient)
* note 0..1 MS
* note.text MS
* note.text ^maxLength = 1024
* note ^short = "Free-text note, used to document relevant measurement-related remarks. Line breaks must be represented as escaped newline characters \\n in JSON and as the character reference &#xA; in XML."
* performer ..1
* performer only Reference(MedComDocumentOrganization)
* extension[valueAttachment].url MS
* extension[valueAttachment] 1..1 MS
* extension[valueAttachment].valueAttachment 1..1 MS
* extension[valueAttachment].valueAttachment.data 1..1 MS
* extension[valueAttachment].valueAttachment.data ^short = "Base64-encoded content of the EKG recording PDF document."
* extension[valueAttachment].valueAttachment.contentType 1..1 MS
* extension[valueAttachment].valueAttachment.contentType = #application/pdf (exactly)
* extension[valueAttachment].valueAttachment.contentType ^short = "MIME type of the attached EKG recording."
* extension[valueAttachment].valueAttachment.title 1..1 MS
* extension[valueAttachment].valueAttachment.title = "Elektrokardiogram-12-aflednings"

// Optional numerical representation of the same recording as the required PDF.
// One synchronized, regularly sampled signal per lead; PDF-only instances remain valid.
* component 0..12
* component ^short = "Optional numerical ECG waveforms, one component per lead"
* component ^definition = "Optional synchronized ECG samples from the recording represented by the PDF. All supplied leads start at effectivePeriod.start, have the same sampling interval and sample count, and cover the effectivePeriod. A subset of the twelve standard leads may be supplied; omitted leads are not available as numerical data."
* component.code from MedComEkgLeadVS (required)
* component.code.coding 1..1
* component.code.coding.system 1..1
* component.code.coding.system = "urn:iso:std:iso:11073:10101" (exactly)
* component.code.coding.code 1..1
* component.value[x] 1..1
* component.value[x] only SampledData
* component.valueSampledData.origin.value 1..1
* component.valueSampledData.origin.system 1..1
* component.valueSampledData.origin.system = "http://unitsofmeasure.org" (exactly)
* component.valueSampledData.origin.code 1..1
* component.valueSampledData.origin.code = #mV (exactly)
* component.valueSampledData.origin.unit = "mV" (exactly)
* component.valueSampledData.period obeys medcom-ekg-positive-sample-period
* component.valueSampledData.dimensions = 1 (exactly)
* component.valueSampledData.data 1..1
* component.valueSampledData.data ^short = "Space-separated samples; amplitude in mV = origin.value + factor * sample (factor defaults to 1)"
* obeys medcom-ekg-waveform-period and medcom-ekg-unique-leads and medcom-ekg-common-sample-period

* insert ProducerShallPutInNarrative(effectiveDateTime)
* insert ProducerShallPutInNarrative(effectivePeriod.start)
* insert ProducerShallPutInNarrative(effectivePeriod.end)
* insert ProducerShallPutInNarrative(code.coding[LOINC].code)
* insert ProducerShallPutInNarrative(code.coding[LOINC].display)
* insert ProducerShallPutInNarrative(code.coding[LOINC].system)
* insert ProducerShallPutInNarrative(note.text)
* insert ProducerShallPutInNarrative(extension[valueAttachment].valueAttachment.contentType)
* insert ProducerShallPutInNarrative(extension[valueAttachment].valueAttachment.title)
