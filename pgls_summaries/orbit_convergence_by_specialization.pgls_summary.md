# Based on Pagel model, species with fovea or area centralis only have significantly higher orbit convergence angle than species with horizontal streak only or other types of retinal specializations
## Orbit convergence by specialization, with size as a covariate, nlme pagel model

```
Generalized least squares fit by REML
  Model: orbit_convergence_merged ~ size + retinal_structure
  Data: pgls_df
       AIC      BIC   logLik
  255.1461 262.1521 -122.573

Correlation Structure: corPagel
 Formula: ~spp
 Parameter estimate(s):
   lambda
0.6750477

Coefficients:
                        Value Std.Error   t-value p-value
(Intercept)          38.79698  9.706711  3.996923  0.0004
size                  4.40701  2.320238  1.899380  0.0672
retinal_structurehs -13.78793  6.416348 -2.148875  0.0398

 Correlation:
                    (Intr) size
size                -0.770
retinal_structurehs -0.346  0.096

Standardized residuals:
       Min         Q1        Med         Q3        Max
-2.5227181 -0.3416507  0.1051166  1.1739274  2.9968029

Residual standard error: 15.46382
Degrees of freedom: 33 total; 30 residual

```

# Based on a simulation phylogenetic ANOVA (Ives and Garland 1993), species with fovea or area centralis only have significantly higher orbit convergence angle than species with horizontal streak only or other types of retinal specializations

```
ANOVA table: Phylogenetic ANOVA

Response: y
           Sum Sq   Mean Sq  F value Pr(>F)
x        5942.512 5942.5116 23.85414 0.0195
Residual 7722.679  249.1187

P-value based on simulation.
---------

Pairwise posthoc test using method = "holm"

Pairwise t-values:
         f_ac      hs
f_ac  0.00000 4.88407
hs   -4.88407 0.00000

Pairwise corrected P-values:
       f_ac     hs
f_ac 1.0000 0.0195
hs   0.0195 1.0000
---------
```
