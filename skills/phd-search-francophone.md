---
name: phd-search-francophone
description: Use this skill when searching for PhD / doctoral / post-doc positions in French-speaking Europe and North America (France, Wallonia-Brussels, Suisse romande, Luxembourg, Québec) — where to look, which mailing lists carry offers before they are published, and the hard filters that disqualify an offer before it is ever scored.
origin: su6i
version: 1.1.0
updated: 2026-09-10
---

# PhD Search — Francophone Sources & Hard Filters

## When to Use

- Any sweep for doctoral / post-doc offers (mailbox digests, site checks, scraper WOs)
- Before scoring an offer's FIT — the exclusions below run **first**
- When setting up or auditing a job/PhD alert or newsletter subscription

## How to Use

1. Run the **hard exclusions** (§A) on the raw text. An excluded offer never enters the list.
2. Score FIT. **< 6/10 → not an option, out of list.** 7/10 is the real target.
3. Only then read the sources in priority order (§B). Mailing lists (§C) beat websites:
   francophone offers arrive there *before* they are published anywhere.
4. Record every checked source with its HTTP status. `[403]` = the site blocks `curl`
   but opens fine in a browser — check it with Chrome, do not drop it.

---

## A. Hard exclusions — reject before scoring

Non-EU nationals (RECE / student / talent permits) are structurally blocked from these:

- **Défense / armement:** Thales (défense), Safran, Dassault Aviation, CS Group, MBDA,
  Naval Group, KNDS/Nexter, ArianeGroup, Airbus Defence, **Eviden** (Atos' critical-systems
  brand — electronic-warfare design offices).
- **Nucléaire:** Framatome, Orano, CEA (sensitive divisions), EDF (nuclear operations).
- **Aerospace / military space. Police, gendarmerie, customs, DGSE/DGSI.**
- **ZRR — Zone à Régime Restrictif / PPST.** A ZRR site requires SGDSN ministerial clearance
  for a non-EU national: unpredictable delay, refusal without stated grounds. Reject outright.
  Text signals: `zone à régime restrictif`, `ZRR`, `PPST`, `protection du potentiel scientifique`,
  `autorisation d'accès`, `enquête administrative`, `avis de sécurité`.
- **Any wording requiring clearance or nationality:** `habilitation`, `habilitable`,
  `secret défense`, `défense nationale`, `nationalité française`, `citoyenneté française`,
  `clearance`, `guerre électronique`, `secteur de la défense`.
- **Driving licence required:** `permis b`, `permis de conduire`, `titulaire du permis`,
  `véhicule (personnel|exigé|indispensable)`. "Permis souhaité/apprécié" → keep, de-prioritise.

**Read the body, never only the employer field.** Case: an Atos "Administrateur réseaux"
posting (Aix-en-Provence, 2026-07-25) — employer "Atos", not on the list, but the text said
"bureau d'étude spécialisé dans la guerre électronique". It was Eviden/Défense.
Trigger case for ZRR: LITIS Le Havre thesis (dynamic graphs + RL), 2026-09-09.

---

## B. Sources — priority ordered

Format: `NAME | URL | note`. `[200]`/`[403]` = HTTP status verified 2026-09-10.

### PRIORITY 1 — France
```
ADUM          | https://www.adum.fr                                                            | Toutes les thèses françaises — source principale
ABG           | https://www.abg.asso.fr/fr/recrutement/sujet-de-these/informatique             | France + international, informatique/IA
Inria Jobs FR | https://jobs.inria.fr/public/classic/fr/offres?filtre=doctorants               | Inria toutes équipes (FR)
Inria Jobs EN | https://jobs.inria.fr/public/classic/en/offres?filtre=doctorants               | Inria toutes équipes (EN)
CNRS          | https://emploi.cnrs.fr/Offres/Recherche.aspx                                   | CNRS offres doctorat + recherche
INRAE         | https://jobs.inrae.fr                                                          | INRAE — agro + data + AI
MADICS        | https://www.madics.fr/offres                                                   | Communauté IA/Data scientifique française
LIG Lab       | https://www.liglab.fr/en/laboratory-overview/joining-lig/recruitments-news     | LIG Grenoble — AI/NLP/ML
Grenoble UGA  | https://recrutement.univ-grenoble-alpes.fr                                     | UGA offres thèse
Montpellier   | https://jobs.univ-montpellier.fr                                               | Université de Montpellier
Euraxess FR   | https://euraxess.fr                                                            | Postes européens en France
ANRT CIFRE    | https://offres-et-candidatures-cifre.anrt.asso.fr                              | Thèses CIFRE (contrat de travail + doctorat)
```

### PRIORITY 2 — Europe francophone hors France

**Belgique (Wallonie + Bruxelles).** KU Leuven, UGent, VUB, UAntwerpen are Flemish and
do **not** count as francophone — that confusion cost a full sweep on 2026-09-10.
```
FNRS BE       | https://www.frs-fnrs.be                                                        | [200] bourses FRIA/Aspirant — vérifier éligibilité non-UE
ULB           | https://www.ulb.be/fr/emploi                                                   | [200] Université libre de Bruxelles
UCLouvain     | https://uclouvain.be/fr/emploi                                                 | [200] Louvain-la-Neuve
ULiège        | https://www.uliege.be/jobs                                                     | [200] Université de Liège
UMONS         | https://web.umons.ac.be/fr/emploi/                                             | [200] Université de Mons
UNamur        | https://www.unamur.be/universite/jobs                                          | [200] Université de Namur
Euraxess BE   | https://www.euraxess.be                                                        | [200] portail belge — filtrer PhD + Computer Science
Academic BE   | https://academicpositions.be                                                   | [403] navigateur
```

**Suisse romande.**
```
EPFL          | https://www.epfl.ch/about/working/working-at-epfl/                             | [200] doctorat via écoles doctorales (EDIC = informatique)
EPFL PhD      | https://www.epfl.ch/education/phd/                                             | [200] candidature centralisée, 2 deadlines/an
UNIGE         | https://www.unige.ch/emploi                                                    | [200] Université de Genève
UNIL          | https://www.unil.ch/unil/fr/home/menuinst/travailler/recrutement-a-l-unil.html | [200] Université de Lausanne
UNINE         | https://www.unine.ch/emploi/                                                   | [200] Université de Neuchâtel
HES-SO        | https://www.hes-so.ch/recherche-innovation/doctorat-et-carrieres-academiques   | [200] doctorat & carrières académiques
Idiap         | https://www.idiap.ch/en/careers                                                | [200] **Martigny — speech/NLP/ML, le labo francophone le plus proche du profil**
myScience CH  | https://www.myscience.ch/jobs                                                  | [403] agrégateur suisse (couvre UNIFR) — navigateur
SNSF/FNS      | https://www.snf.ch                                                             | [200] financements doctoraux
```

**Luxembourg.**
```
Uni.lu        | https://www.uni.lu/en/about/work/explore-our-jobs/                             | [200] filtre "Researcher"; IAS Young Academics = sujet libre, 48 mois
LIST jobs     | https://www.list.lu/career/job-offers                                          | [200]
LIST PhD      | https://www.list.lu/career/phd-community                                       | [200]
LISER         | https://www.liser.lu                                                           | [200] socio-économie, data
```

### PRIORITY 2b — Québec
In Québec a doctorate is an **admission**, not an answer to a posting: secure a
*directeur de recherche* first, then the funding.
```
Mila          | https://mila.quebec                                                            | [200] **plus grand institut académique d'apprentissage profond**
IVADO         | https://ivado.ca                                                               | [200] bourses et programmes IA/données
Mitacs        | https://www.mitacs.ca                                                          | [200] Accelerate / Globalink
FRQ Québec    | https://frq.gouv.qc.ca                                                         | [200] bourses doctorat (B2)
UdeM          | https://carrieres.umontreal.ca                                                 | [200]
Polytechnique | https://www.polymtl.ca/carriere                                                | [200]
HEC Montréal  | https://www.hec.ca/emplois-jobopenings/                                        | [200] piste IA & finance
UQAM          | https://carrieres.uqam.ca                                                      | [200]
ÉTS           | https://www.etsmtl.ca/emplois                                                  | [200]
INRS          | https://inrs.ca/emplois                                                        | [200]
U. Laval      | https://emplois.ulaval.ca                                                      | [200]
U. Sherbrooke | https://www.usherbrooke.ca/emplois/                                           | [403] navigateur
McGill        | https://www.mcgill.ca/hr/careers                                              | [200] anglophone, mais Montréal
ACFAS         | https://www.acfas.ca                                                          | [200] annonces & réseau francophone
```

### PRIORITY 3 — Europe (English)
```
Euraxess EU   | https://euraxess.ec.europa.eu/jobs/search   | filtrer IA/ML
Academic EU   | https://academicpositions.eu                | postes académiques Europe
NLP People    | https://nlppeople.com                       | NLP/ML mondial — très actif
FindAPhD      | https://www.findaphd.com                    | UK + monde
Academic UK   | https://jobs.ac.uk                          | UK
Academic NL   | https://academic-transfer.com               | Pays-Bas
ScholarshipDB | https://scholarshipdb.net/NLP-scholarships/Program-PhD | NLP PhD monde
```

---

## C. Mailing lists — subscribe, they beat every website

Addresses are written `nom (at) domaine` (the repo's pre-commit hook rejects literal
addresses); restore the `@` when you subscribe.

```
bull-ia (at) gdria.fr                  AFIA / GDR RADIA — la source n°1 en français (thèses, post-docs)
proml (at) listes.univ-rennes.fr       ML France — c'est par là qu'est arrivée l'offre LITIS Rouen
bull-i3 (at) irit.fr                   IRIT Toulouse
info-ic (at) listes.irisa.fr           ingénierie des connaissances / web sémantique
sma (at) loria.fr                      systèmes multi-agents
ln (at) groupes.renater.fr             TAL / langage naturel (ATALA)
liste-egc (at) polytech.univ-nantes.fr Extraction et Gestion des Connaissances
flashinfo (at) afia.asso.fr            AFIA — https://afia.asso.fr
webmaster (at) abg.asso.fr             ABG, infolettre mensuelle
```

## D. Known trap — Academic Positions alerts

The site's field list has **no AI/ML keyword**. An alert built on
`computer-science + europe + north-america` returned 12 digests in 14 days, almost all
Nordic and off-topic. Restricting it to the 4 francophone European countries (done
2026-09-10) narrows the noise but does not fix the missing field. Treat this channel as
**secondary** — the mailing lists in §C are worth more.

---

## E. Alert / subscription status (verified in browser 2026-09-10)

| Channel | Alert possible? | State |
|---|---|---|
| **IVADO** `ivado.ca/en/subscribe-to-our-newsletter/` | yes, plain form | **subscribed** — monthly general + events newsletter |
| **myScience CH** `myscience.ch/account/my_alerts` | yes, but **account required** | not done — owner must register |
| **EURAXESS** `euraxess.ec.europa.eu/jobs/search` | yes, but **EU Login account required** | not done — owner must register. `euraxess.be` is an information portal only: it carries no job alert of its own |
| **Mila** | **no alert exists** | not an alert channel. PhD entry is the *supervision request* cycle (`/en/prospective-students-and-postdocs/research-programs/request-supervisor`), and staff jobs sit on a Workable board (`apply.workable.com/mila-2/`). Virtual information sessions are announced on `/en/prospective-students/virtual-information-sessions` |
| **Idiap** | none | careers page has no alert, no feed — poll it |
| **FNRS** | none public | `FNRS.express` page publishes archives only, no subscription form |

**Rule of thumb this check produced:** in francophone Europe the job-alert layer is almost
entirely account-gated, while Québec's is a plain newsletter form. Anything account-gated
has to be created by the owner personally — an agent must not create accounts or enter
passwords. When a source turns out to be account-gated, record it here rather than
re-discovering it next sweep.
