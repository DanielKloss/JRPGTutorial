class_name Types extends RefCounted

enum elements {NONE, CODE, DESIGN, ART, BUG}

const weaknessMapping = {
	elements.NONE: -1,
	elements.CODE: elements.ART,
	elements.ART: elements.DESIGN,
	elements.DESIGN: elements.CODE,
	elements.BUG: -1
}
