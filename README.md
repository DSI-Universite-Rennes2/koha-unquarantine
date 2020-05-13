# Koha Unquarantine Script

## English version

This script 

### Usage
```bash
perl unquarantine.pl [qc] [qd]

ARGUMENTS:
  qc	Code of the quarantine status, must be a possible value of items.notforloan (integer)
  qd	Duration of the quarantine in days (positive integer, 10 by default)
```

### Setup
1. Create a custom value in the _NOT\_LOAN_ authorised values' category (for example '9'->'On quarantine')
2. Modify the `UpdateNotForLoanStatusOnCheckin` system preference for put automaticaly your custom NotForLoan status on item check in (for example `0: 9`). 
3. Enable the script daily in your koha crontab and set up the arguments : first is your custom NotForLoan status, second is quarantine duration in days (for example `@daily perl unquarantine.pl 9 10`)

## Version française

Ce script permet de remettre un statut NotForLoan disponible 

### Utilisation
```bash
perl unquarantine.pl [qc] [qd]

ARGUMENTS:
  qc	Code du statut de quarantaine, doit être une valeur possible de items.notforloan (entier)
  qd	Durée de la quarantaine en jours (entier positif, 10 par défaut)
```

### Installation
1. Créez une valeur autorisée personnalisé dans la catégorie _NOT\_LOAN_ (par exemple '9'->'En quarantaine')
2. Modifiez la préférence système `UpdateNotForLoanStatusOnCheckin` pour appliquer automatiquement votre statut NotForLoan personnalisé au retour d'un exemplaire disponilbe (par exemple `0: 9`)
3. Activez ce script de façon quotidienne dans votre crontab koha et définissez les arguments : le premier est votre statut NorForLoan personnalisé, le second est la durée de la quarantaine en jours (par exemple `@daily perl unquarantine.pl 9 10`)
