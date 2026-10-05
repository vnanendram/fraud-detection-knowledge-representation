# Fraud Detection with Knowledge Representation

University group project focused on the development of a knowledge-based fraud detection system for credit card transactions.

The project was completed as part of the module **Wissensrepräsentation und -verarbeitung**.

## Academic Result

- **Group Project Grade:** 5.5 / 6.0

## Project Overview

The objective of this project was to model a rule-based system that evaluates the risk of credit card transactions.

The system calculates a transaction risk score based on several factors and derives a final decision from that score.

Possible outcomes are:

- **Accepted** – risk score below 100
- **Stopped for review** – risk score from 100 to below 150
- **Rejected** – risk score of 150 or higher

The project applies different knowledge representation approaches to the same fraud detection problem.

## Knowledge Representation Approaches

### DMN

Decision Model and Notation (DMN) was used to represent the fraud detection logic through structured decisions and decision tables.

The model includes rules for:

- Cardholder region risk
- Merchant region risk
- Transaction amount risk
- Time-difference risk
- Merchant-cardholder restrictions
- Overall transaction risk
- Final transaction decision

### Prolog

A Prolog implementation was developed to represent the fraud detection rules using facts and logical inference.

The model derives information such as:

- Cardholder country and region
- Merchant country and region
- Partial risk values
- Overall transaction risk
- Final transaction decision

### Ontology / OWL

An ontology was created to represent the main concepts and relationships of the fraud detection domain.

Examples include:

- Transactions
- Credit cards
- Cardholders
- Merchants
- Countries
- Regions
- Transaction decisions

### Datalog & Knowledge Graph

Datalog rules were used together with RDF data to derive additional knowledge from the fraud detection model.

### SPARQL

SPARQL queries were used to retrieve and analyse information from the knowledge graph.

## Technologies & Concepts

- DMN
- Prolog
- OWL / Ontologies
- RDF / Turtle
- Datalog
- SPARQL
- Knowledge Graphs
- Rule-Based Systems
- Logical Inference
- Knowledge Representation
- SWRL
- Protégé

## My Contribution

This project was developed collaboratively by a three-person team. We worked closely together across all major parts of the project rather than assigning isolated technical components to individual members.

My contribution therefore included collaborative work on:

- Designing and refining the DMN decision model
- Developing and testing the Prolog implementation
- Creating and structuring the ontology in OWL
- Modelling RDF/Turtle data and Datalog rules
- Writing and testing SPARQL queries
- Working with SWRL rules and Protégé
- Discussing modelling decisions and limitations
- Testing the different knowledge representation approaches
- Preparing and reviewing the final project documentation

The project was developed through continuous teamwork, shared review and joint decision-making.

## Repository Structure

```text
fraud-detection-knowledge-representation/
│
├── dmn/
│   └── fraud_detection.dmn
│
├── prolog/
│   └── fraud_detection.pl
│
├── ontology/
│   ├── fraud_ontology.owl
│   └── fraud_ontology.pdf
│
├── datalog/
│   ├── fraud_data.ttl
│   └── fraud_rules.dlog
│
├── sparql/
│   ├── queries_4c.sparql
│   └── queries_4d.sparql
│
├── documentation/
│   └── final_documentation.pdf
│
└── README.md
