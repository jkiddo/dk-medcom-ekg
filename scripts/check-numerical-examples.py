"""Check compiled example signal integrity and Bundle references after running SUSHI."""
import base64
import json
from datetime import datetime
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RESOURCES = ROOT / "fsh-generated/resources"


def load(kind, identifier):
    return json.loads((RESOURCES / f"{kind}-{identifier}.json").read_text())


def check():
    expected_codes = ["131329", "131330", "131389", "131390", "131391", "131392",
                      "131331", "131332", "131333", "131334", "131335", "131336"]
    observations = []
    for identifier, count in [("66d6516f-382d-442f-993f-9eb96f0700f6", 12),
                               ("db5dd8eb-0432-4745-9522-a48932122faf", 3)]:
        obs = load("Observation", identifier)
        assert len(obs["component"]) == count
        assert [c["code"]["coding"][0]["code"] for c in obs["component"]] == expected_codes[:count]
        duration = (datetime.fromisoformat(obs["effectivePeriod"]["end"]) -
                    datetime.fromisoformat(obs["effectivePeriod"]["start"])).total_seconds()
        for component in obs["component"]:
            assert component["code"]["coding"][0]["system"] == "urn:iso:std:iso:11073:10101"
            signal = component["valueSampledData"]
            samples = list(map(int, signal["data"].split()))
            assert len(samples) == 500
            assert signal["dimensions"] == 1 and signal["period"] == 2
            assert signal["origin"]["system"] == "http://unitsofmeasure.org"
            assert signal["origin"]["code"] == "mV" and signal["origin"]["value"] == 0
            assert signal["factor"] == 0.001
            assert len(samples) * signal["period"] / 1000 == duration == 1
            assert min(samples) < max(samples), "A lead must contain a signal, not only placeholders"
        attachment = next(e["valueAttachment"] for e in obs["extension"] if "valueAttachment" in e)
        assert attachment["contentType"] == "application/pdf"
        assert base64.b64decode(attachment["data"], validate=True) == (ROOT / "input/images/ekg-synthetic-waveforms.pdf").read_bytes()
        observations.append(obs)
    assert observations[0]["component"][:3] == observations[1]["component"]
    samples = [list(map(int, c["valueSampledData"]["data"].split())) for c in observations[0]["component"]]
    for i, ii, iii, avr, avl, avf in zip(*samples[:6]):
        assert iii == ii-i and 2*avr == -(i+ii) and 2*avl == 2*i-ii and 2*avf == 2*ii-i
    bundle = load("Bundle", "83f3b8a2-a94d-4221-aacf-13e72e534cf2")
    assert bundle["type"] == "document" and bundle["entry"][0]["resource"]["resourceType"] == "Composition"
    entries = {e["resource"]["resourceType"] + "/" + e["resource"]["id"]: e["resource"] for e in bundle["entry"]}
    assert entries["Observation/" + observations[0]["id"]] == observations[0]

    def references(value):
        if isinstance(value, dict):
            if "reference" in value:
                assert value["reference"] in entries, value["reference"]
            for child in value.values(): references(child)
        elif isinstance(value, list):
            for child in value: references(child)
    references(bundle)
    assert "component" not in load("Observation", "ef810168-ee8c-4f14-9012-6aff6c1d86e7")
    print("PASS: 12-lead and 3-lead sample arrays, scaling, timing, limb relationships, embedded PDFs, Bundle references, and PDF-only example.")


if __name__ == "__main__":
    check()
