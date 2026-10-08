## Introduction

The EKG project has been established with the overall objective of supporting secure, consistent, and nationwide sharing of electrocardiograms (EKGs) across healthcare providers. Today, EKGs are recorded both in general practice and in regional healthcare settings, and there is a clinical and organizational need to make these EKGs accessible across sectors, regardless of the originating system.

As part of the project, it has been decided that EKGs recorded in general practice and regional healthcare services shall be shared as PDF documents. This approach has been chosen to ensure a pragmatic and widely applicable solution that can be supported by existing clinical IT systems while preserving the correct visual representation of the EKG.

Sharing of EKGs will take place via the National Service Platform (NSP) using the Document Sharing Service (DDS), which is already used for national sharing of healthcare documents and thus provides a proven and secure infrastructure.

The FHIR standard will ensure consistent structuring of metadata and clinically relevant information, enabling EKGs to be searched, interpreted, and used correctly by receiving systems and clinicians.

### MedCom EKG Recording
The structure of an EKG Recording is depicted on the following diagram:

<img alt="Shows the general MedCom document model. Each document must at least contain the following resources: Bundle, Composition, Organization, Patient and use case specific resources." src="./EkgDocumentModel.svg" style="float:none; display:block; margin-left:auto; margin-right:auto;" />

The figure shows the structure of an EKG Recording. It represents the structure and references of a MedCom EKG Recording document Bundle, including the relationships between Bundle, Composition, Observation, Patient, Organization, Practitioner, PractitionerRole, and AuthorPerson.

The Bundle serves as the container for all resources included in the message. All resources are included as entries in the Bundle, and all references between resources are resolved internally within the same Bundle.

The first entry in the Bundle is the Composition, and defines the overall clinical and structural context of the message. The Composition references the Observation resource as its content entry.

In addition to Composition and Observation, the Bundle includes the Patient, Organization, PractitionerRole, and Practitioner resources. These resources provide the clinical subject and the organizational and professional context of the message. The use of PractitionerRole and Practitioner is optional.

The EKG Recording standard follows the general MedCom FHIR Document model.

### EKG Recording in FHIR
The IG is designed to represent a complete EKG recording in FHIR, provided as a PDF document with the option to add a note. This note will typically provide guidance to the recipient regarding conditions or details that may have influenced the EKG recording.

The Observation may additionally include numerical ECG waveforms as optional
per-lead `SampledData` components. The PDF remains required, and PDF-only recordings
remain supported. See the [Observation guidance](StructureDefinition-medcom-ekg-recording-observation.html)
for sample scaling, lead codes, synchronized timing, and the relationship to the
HL7 PoCD and PHD models.

#### Terminology IG and metadata IG
In the [MedCom Terminology IG](http://medcomfhir.dk/ig/terminology/) all referenced MedCom Terminology code systems and value sets developed by MedCom can be found.

In the [MedCom Terminology for XDS Metadata](https://medcomfhir.dk/ig/xdsmetadata/) all MedCom code systems and value sets related to metadata can be found.

**Note** that the IG versions linked may be newer than the versions used as dependencies in this implementation guide. For the exact dependency versions applied, see the **Dependencies** tab in the top menu under **More**.

#### Dependencies
Besides Terminology and metadata IGs, this IG has a dependency to the [MedCom Core IG](http://medcomfhir.dk/ig/core/), [DK-core](https://hl7.dk/fhir/core/), defined by [HL7 Denmark](https://hl7.dk/), [MedCom Document IG](https://medcomfhir.dk/ig/document/), and [IHE MHD](https://profiles.ihe.net/ITI/MHD/). **Note** that the IG versions linked may be newer than the versions used as dependencies in this implementation guide. For the exact dependency versions applied, see the **Dependencies** tab in the top menu under **More**.
