# Koha Unquarantine Script

## English version

This script modifies items with a custom NotForLoan attribute to set it back to available after a definable time

### Usage
```bash
perl unquarantine.pl [qc] [qd] [qb]

ARGUMENTS:
  qc	Code of the quarantine status, must be a possible value of items.notforloan (integer)
  qd	Duration of the quarantine in days (positive integer, 10 by default)
  qb	Code for a specific holding branch (optional), leave empty if all branches are targeted
```

### Setup
1. Create a custom value in the _NOT\_LOAN_ authorised values' category (for example '9'->'On quarantine')
2. Modify the `UpdateNotForLoanStatusOnCheckin` system preference for put automaticaly your custom NotForLoan status on item check in (for example `0: 9`). 
3. Enable the script daily in your koha crontab and set up the arguments : first is your custom NotForLoan status, second is quarantine duration in days (for example `@daily perl unquarantine.pl 9 10`)

### Reporting security issues
We take security seriously. If you discover a security issue, please bring it to their attention right away!

Please **DO NOT** file a public issue, instead send your report privately to [foss-security@univ-rennes2.fr](mailto:foss-security@univ-rennes2.fr).

Security reports are greatly appreciated and we will publicly thank you for it.

## Version française

Ce script modifie les exemplaires ayant un attribute NotForLOan personnalisé pour les rendre de nouveau disponible après un durée paramétrable

### Utilisation
```bash
perl unquarantine.pl [qc] [qd] [qb]

ARGUMENTS:
  qc	Code du statut de quarantaine, doit être une valeur possible de items.notforloan (entier)
  qd	Durée de la quarantaine en jours (entier positif, 10 par défaut)
  qb Code pour une bibliothèque spécifique (holdingbranch), laisser vide si vous souhaitez impacter les exemplaires de toutes les bibliothèques
```

### Installation
1. Créez une valeur autorisée personnalisé dans la catégorie _NOT\_LOAN_ (par exemple '9'->'En quarantaine')
2. Modifiez la préférence système `UpdateNotForLoanStatusOnCheckin` pour appliquer automatiquement votre statut NotForLoan personnalisé au retour d'un exemplaire disponilbe (par exemple `0: 9`)
3. Activez ce script de façon quotidienne dans votre crontab koha et définissez les arguments : le premier est votre statut NorForLoan personnalisé, le second est la durée de la quarantaine en jours (par exemple `@daily perl unquarantine.pl 9 10`)

### Signaler une vulnérabilité
Nous prenons la sécurité au sérieux. Si vous découvrez une vulnérabilité, veuillez nous en informer au plus vite !

S'il vous plait **NE PUBLIEZ PAS** un rapport de bug public. A la place, envoyez nous un rapport privé à [foss-security@univ-rennes2.fr](mailto:foss-security@univ-rennes2.fr).

Les rapports de sécurité sont grandement appréciés et nous vous en remercierons publiquement.
