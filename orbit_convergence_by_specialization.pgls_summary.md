# Based on BM model, no significant difference between retinal specializations
## Orbit convergence by specialization, with size as a covariate, nlme BM

```
Generalized least squares fit by REML
  Model: orbit_convergence_merged ~ size + retinal_structure
  Data: pgls_df
       AIC      BIC    logLik
  300.6824 308.4591 -145.3412

Correlation Structure: corBrownian
 Formula: ~spp
 Parameter estimate(s):
numeric(0)

Coefficients:
                         Value Std.Error   t-value p-value
(Intercept)           41.02250 12.138947  3.379412  0.0018
size                   1.61078  0.860921  1.870994  0.0697
retinal_structurehs  -13.77987  6.803323 -2.025462  0.0505
retinal_structuremix -14.90049  8.190638 -1.819210  0.0774

 Correlation:
                     (Intr) size   rtnl_strctrh
size                 -0.534
retinal_structurehs  -0.265 -0.018
retinal_structuremix -0.436  0.066  0.360

Standardized residuals:
        Min          Q1         Med          Q3         Max
-0.99258783 -0.25115644 -0.02483206  0.53899798  2.20167595

Residual standard error: 21.66082
Degrees of freedom: 39 total; 35 residual

         Simultaneous Tests for General Linear Hypotheses

Multiple Comparisons of Means: Tukey Contrasts


Fit: gls(model = orbit_convergence_merged ~ size + retinal_structure,
    data = pgls_df, correlation = corBM)

Linear Hypotheses:
                Estimate Std. Error z value Pr(>|z|)
hs - f_ac == 0   -13.780      6.803  -2.025    0.105
mix - f_ac == 0  -14.900      8.191  -1.819    0.162
mix - hs == 0     -1.121      8.560  -0.131    0.991
(Adjusted p values reported -- single-step method)

```

# Based on Pagel model, species with fovea or area centralis only have significantly higher orbit convergence angle than species with horizontal streak only or other types of retinal specializations
## Orbit convergence by specialization, with size as a covariate, nlme pagel model

```
Generalized least squares fit by REML
  Model: orbit_convergence_merged ~ size + retinal_structure
  Data: pgls_df
       AIC      BIC    logLik
  294.8625 304.1946 -141.4312

Correlation Structure: corPagel
 Formula: ~spp
 Parameter estimate(s):
   lambda
0.8269755

Coefficients:
                         Value Std.Error   t-value p-value
(Intercept)           42.18913  9.363658  4.505625  0.0001
size                   1.63045  0.805318  2.024608  0.0506
retinal_structurehs  -14.94645  5.719281 -2.613344  0.0131
retinal_structuremix -16.40097  6.389663 -2.566797  0.0147

 Correlation:
                     (Intr) size   rtnl_strctrh
size                 -0.645
retinal_structurehs  -0.308  0.013
retinal_structuremix -0.410  0.015  0.399

Standardized residuals:
        Min          Q1         Med          Q3         Max
-1.38682776 -0.35274411 -0.02907827  0.76504913  3.00283066

Residual standard error: 15.41597
Degrees of freedom: 39 total; 35 residual

         Simultaneous Tests for General Linear Hypotheses

Multiple Comparisons of Means: Tukey Contrasts


Fit: gls(model = orbit_convergence_merged ~ size + retinal_structure,
    data = pgls_df, correlation = corPagel)

Linear Hypotheses:
                Estimate Std. Error z value Pr(>|z|)
hs - f_ac == 0   -14.946      5.719  -2.613   0.0241 *
mix - f_ac == 0  -16.401      6.390  -2.567   0.0275 *
mix - hs == 0     -1.455      6.663  -0.218   0.9740
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
(Adjusted p values reported -- single-step method)
```

# Pagel's lambda models are significantly more likely than Brownian motion models
## Adding size as a covariate significantly improves models
```
[1] "BM vs Pagel:"
Likelihood ratio = 7.4297(df=1) P = 0.006416
[1] "BM vs BM with size as covariate:"
Likelihood ratio = 4.956(df=1) P = 0.026
[1] "Pagel vs Pagel with size as covariate:"
Likelihood ratio = 5.3462(df=1) P = 0.02077
[1] "BM vs Pagel, both with size as covariate:"
Likelihood ratio = 7.8199(df=1) P = 0.005167
```

# Based on a simulation phylogenetic ANOVA (Ives and Garland 1993), species with fovea or area centralis only have significantly higher orbit convergence angle than species with horizontal streak only or other types of retinal specializations

```
ANOVA table: Phylogenetic ANOVA

Response: y
           Sum Sq   Mean Sq   F value Pr(>F)
x        6187.113 3093.5567 15.020102 0.0173
Residual 7414.600  205.9611

P-value based on simulation.
---------

Pairwise posthoc test using method = "holm"

Pairwise t-values:
          f_ac       hs       mix
f_ac  0.000000 5.111035  4.251792
hs   -5.111035 0.000000 -1.216029
mix  -4.251792 1.216029  0.000000

Pairwise corrected P-values:
       f_ac     hs    mix
f_ac 1.0000 0.0048 0.0584
hs   0.0048 1.0000 0.5986
mix  0.0584 0.5986 1.0000
---------
```

# Similar results when excluding "mix" or "other" categories (i.e., only compare species with a horizontal streak only to those that have a fovea or area centralis only)
## retinal specialization only, nlme BM
```
Generalized least squares fit by REML
  Model: orbit_convergence_merged ~ retinal_structure
  Data: pgls_df
       AIC      BIC    logLik
  190.0149 193.2881 -92.00747

Correlation Structure: corBrownian
 Formula: ~spp
 Parameter estimate(s):
numeric(0)

Coefficients:
                        Value Std.Error   t-value p-value
(Intercept)          54.59991 10.045191  5.435428   0.000
retinal_structurehs -13.72551  7.584701 -1.809631   0.084

 Correlation:
                    (Intr)
retinal_structurehs -0.339

Standardized residuals:
        Min          Q1         Med          Q3         Max
-1.02632331 -0.42080660 -0.08127238  0.55077028  2.34905510

Residual standard error: 22.60487
Degrees of freedom: 24 total; 22 residual
```
## retinal specialization only, nlme pagel model
```
Generalized least squares fit by REML
  Model: orbit_convergence_merged ~ retinal_structure
  Data: pgls_df
       AIC      BIC    logLik
  189.2101 193.5742 -90.60503

Correlation Structure: corPagel
 Formula: ~spp
 Parameter estimate(s):
   lambda
0.7788895

Coefficients:
                        Value Std.Error   t-value p-value
(Intercept)          56.00001  7.235136  7.740007  0.0000
retinal_structurehs -15.92980  6.782646 -2.348611  0.0282

 Correlation:
                    (Intr)
retinal_structurehs -0.425

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.4579267 -0.5734783 -0.1241732  0.6548813  3.0640158

Residual standard error: 16.87328
Degrees of freedom: 24 total; 22 residual
```
## Orbit convergence by specialization, with size as a covariate, nlme BM
```
Generalized least squares fit by REML
  Model: orbit_convergence_merged ~ size + retinal_structure
  Data: pgls_df
       AIC      BIC    logLik
  179.4196 183.5977 -85.70981

Correlation Structure: corBrownian
 Formula: ~spp
 Parameter estimate(s):
numeric(0)

Coefficients:
                         Value Std.Error   t-value p-value
(Intercept)          27.129074 11.114724  2.440823  0.0236
size                  3.980485  1.105286  3.601315  0.0017
retinal_structurehs -14.289664  6.105882 -2.340311  0.0292

 Correlation:
                    (Intr) size
size                -0.686
retinal_structurehs -0.229 -0.026

Standardized residuals:
        Min          Q1         Med          Q3         Max
-1.18748664 -0.31385864  0.05332418  0.78324690  1.84976856

Residual standard error: 18.19152
Degrees of freedom: 24 total; 21 residual
```
## Orbit convergence by specialization, with size as a covariate, nlme pagel model
```
Generalized least squares fit by REML
  Model: orbit_convergence_merged ~ size + retinal_structure
  Data: pgls_df
       AIC      BIC    logLik
  175.9758 181.1984 -82.98788

Correlation Structure: corPagel
 Formula: ~spp
 Parameter estimate(s):
  lambda
1.019916

Coefficients:
                        Value Std.Error   t-value p-value
(Intercept)          40.44393  8.078846  5.006152  0.0001
size                  1.85104  0.873432  2.119276  0.0462
retinal_structurehs -12.93825  4.777338 -2.708255  0.0132

 Correlation:
                    (Intr) size
size                -0.755
retinal_structurehs -0.231  0.003

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.7141897 -0.6126633 -0.1351658  1.3412394  4.0016716

Residual standard error: 11.35438
Degrees of freedom: 24 total; 21 residual
```

# Compare model likelihoods
```
BM vs Pagel:
Likelihood ratio = 2.8049(df=1) P = 0.09398
BM vs BM with size as covariate
Likelihood ratio = 12.595(df=1) P = 0.0003867
Pagel vs Pagel with size as covariate
Likelihood ratio = 15.234(df=1) P = 9.496e-05
BM vs Pagel, both with size as covariate
Likelihood ratio = 5.4439(df=1) P = 0.01964
```

# Similar results with simulation approach (Ives and Garland 1993, phylANOVA)
```
ANOVA table: Phylogenetic ANOVA

Response: y
           Sum Sq   Mean Sq   F value Pr(>F)
x        5380.256 5380.2563 21.957369 0.0066
Residual 5390.702  245.0319

P-value based on simulation.
---------

Pairwise posthoc test using method = "holm"

Pairwise t-values:
          f_ac       hs
f_ac  0.000000 4.685869
hs   -4.685869 0.000000

Pairwise corrected P-values:
       f_ac     hs
f_ac 1.0000 0.0066
hs   0.0066 1.0000
---------
```