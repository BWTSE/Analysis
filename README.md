# Replication Package

[![DOI](https://zenodo.org/badge/349066817.svg)](https://zenodo.org/badge/latestdoi/349066817)

This repository contains a replication package used to investigate the Broken Windows Theory of Software Engineering. 

The package contains a [presentation](https://bwtse.github.io/Analysis/index.html) as well as the source for the whole analysis performed.

Read the thesis for more information and justification about the analysis and procedure.

## Notes

If you have any questions or feel that anything in the replication package is amiss, please [open an issue](https://github.com/BWTSE/Analysis/issues).

1. Most models have been run with moment matching to improve pareto-k diagnostics. We found no consistent errors in the loo estimates and did not include the moment matching in the replication package due to its resource intensiveness.
2. Seeds have been used where possible to reduce the effects of randomness for those who wish to execute this replication package themselves. All steps does however not support seeding (especially loo and posterior sampling) and may therefore produce slightly different results on each execution. Seeds were selected as the date of the day they were introduced on.
