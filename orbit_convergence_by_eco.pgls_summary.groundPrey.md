# Based on Brownian motion model, orbit convergence is associated with arboreal foraging
## Arboreal hypothesis, nlme BM
```
Generalized least squares fit by REML
  Model: oc ~ forstrat
  Data: smallHerb_df
       AIC      BIC    logLik
  657.9593 665.2873 -325.9797

Correlation Structure: corBrownian
 Formula: ~spp
 Parameter estimate(s):
numeric(0)

Coefficients:
               Value Std.Error  t-value p-value
(Intercept) 35.38843  8.655672 4.088468  0.0001
forstratG    7.09775  2.909419 2.439577  0.0168

 Correlation:
          (Intr)
forstratG -0.209

Standardized residuals:
       Min         Q1        Med         Q3        Max
-0.9806513 -0.3213941  0.3582150  1.0633113  2.8440580

Residual standard error: 22.92985
Degrees of freedom: 87 total; 85 residual
```

# Based on Pagel's lambda model, orbit convergence is not associated with arboreal foraging
## Arboreal hypothesis, nlme Pagel
```
Generalized least squares fit by REML
  Model: oc ~ forstrat
  Data: smallHerb_df
       AIC      BIC    logLik
  643.6376 653.4082 -317.8188

Correlation Structure: corPagel
 Formula: ~spp
 Parameter estimate(s):
   lambda
0.8865929

Coefficients:
               Value Std.Error  t-value p-value
(Intercept) 38.20333  5.801592 6.584974  0.0000
forstratG    3.17336  3.053842 1.039136  0.3017

 Correlation:
          (Intr)
forstratG -0.322

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.3756018 -0.4240709  0.4566744  1.4734132  4.2679417

Residual standard error: 15.53988
Degrees of freedom: 87 total; 85 residual
```

# Similar results with size as a covariate
## Arboreal hypothesis, with size as covariate, nlme BM
```
Generalized least squares fit by REML
  Model: oc ~ size + forstrat
  Data: smallHerb_df
       AIC      BIC    logLik
  655.7766 665.4999 -323.8883

Correlation Structure: corBrownian
 Formula: ~spp
 Parameter estimate(s):
numeric(0)

Coefficients:
                Value Std.Error  t-value p-value
(Intercept) 27.313407  9.713326 2.811952  0.0061
size         1.232914  0.703210 1.753266  0.0832
forstratG    6.006656  2.941154 2.042279  0.0443

 Correlation:
          (Intr) size
size      -0.474
forstratG -0.079 -0.212

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.0862847 -0.3268589  0.2323659  1.0298636  2.6416402

Residual standard error: 22.65513
Degrees of freedom: 87 total; 84 residual
```
## Arboreal hypothesis, with size as covariate, nlme Pagel
```
Generalized least squares fit by REML
  Model: oc ~ size + forstrat
  Data: smallHerb_df
       AIC      BIC    logLik
  640.8318 652.9859 -315.4159

Correlation Structure: corPagel
 Formula: ~spp
 Parameter estimate(s):
   lambda
0.8850395

Coefficients:
                Value Std.Error  t-value p-value
(Intercept) 30.177368  6.966262 4.331932  0.0000
size         1.221200  0.609856 2.002439  0.0485
forstratG    1.787102  3.077679 0.580665  0.5630

 Correlation:
          (Intr) size
size      -0.578
forstratG -0.131 -0.219

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.5178581 -0.3920441  0.3977456  1.3851717  4.0257545

Residual standard error: 15.23699
Degrees of freedom: 87 total; 84 residual
```

# Pagel's lambda models significantly more likely; therefore concluding that orbit convergence is NOT significantly associated with arboreality after phylogenetic correction
```
[1] "res_arb_BM vs res_arb_P"
Likelihood ratio = 16.322(df=1) P = 5.345e-05
[1] "res_arbSize_BM vs res_arbSize_P"
Likelihood ratio = 16.945(df=1) P = 3.848e-05
```

# No support for the hypothesis that small prey species have lower orbit convergence
## Small herbivore (prey) hypothesis, no interaction, nlme BM
```
Generalized least squares fit by REML
  Model: oc ~ size + forstrat + herb
  Data: smallHerb_df
       AIC      BIC    logLik
  653.4543 665.5485 -321.7272

Correlation Structure: corBrownian
 Formula: ~spp
 Parameter estimate(s):
numeric(0)

Coefficients:
                Value Std.Error   t-value p-value
(Intercept) 25.859404  9.831624 2.6302272  0.0102
size         1.192104  0.704712 1.6916183  0.0945
forstratG    6.291048  2.956750 2.1276906  0.0363
herbyes      2.098706  2.163215 0.9701791  0.3348

 Correlation:
          (Intr) size   frstrG
size      -0.459
forstratG -0.093 -0.216
herbyes   -0.152 -0.060  0.099

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.1074175 -0.3498513  0.2732625  1.0441508  2.6209465

Residual standard error: 22.66306
Degrees of freedom: 87 total; 83 residual
```

## Small herbivore (prey) hypothesis, no interaction, nlme Pagel
```
Generalized least squares fit by REML
  Model: oc ~ size + forstrat + herb
  Data: smallHerb_df
       AIC      BIC    logLik
  638.6024 653.1155 -313.3012

Correlation Structure: corPagel
 Formula: ~spp
 Parameter estimate(s):
   lambda
0.8889022

Coefficients:
                Value Std.Error  t-value p-value
(Intercept) 29.148844  7.229823 4.031751  0.0001
size         1.173615  0.619104 1.895668  0.0615
forstratG    2.114704  3.110011 0.679967  0.4984
herbyes      1.587781  2.837496 0.559571  0.5773

 Correlation:
          (Intr) size   frstrG
size      -0.521
forstratG -0.156 -0.232
herbyes   -0.235 -0.139  0.128

Standardized residuals:
      Min        Q1       Med        Q3       Max
-1.527114 -0.416213  0.469917  1.408910  3.965006

Residual standard error: 15.38823
Degrees of freedom: 87 total; 83 residual
```

## Small herbivore (prey) hypothesis, with forstrat:herb interaction, nlme BM
```
Generalized least squares fit by REML
  Model: oc ~ size + forstrat + herb + forstrat:herb
  Data: smallHerb_df
       AIC      BIC  logLik
  648.9201 663.3604 -318.46

Correlation Structure: corBrownian
 Formula: ~spp
 Parameter estimate(s):
numeric(0)

Coefficients:
                      Value Std.Error   t-value p-value
(Intercept)       26.618535  9.805879 2.7145486  0.0081
size               1.236297  0.702452 1.7599749  0.0821
forstratG          2.365918  4.193771 0.5641504  0.5742
herbyes            0.724460  2.394252 0.3025830  0.7630
forstratG:herbyes  5.809314  4.420625 1.3141386  0.1925

 Correlation:
                  (Intr) size   frstrG herbys
size              -0.455
forstratG         -0.107 -0.186
herbyes           -0.163 -0.075  0.374
forstratG:herbyes  0.059  0.048 -0.712 -0.437

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.1896894 -0.3514053  0.3937061  1.0724395  2.5530708

Residual standard error: 22.56445
Degrees of freedom: 87 total; 82 residual
```

## Small herbivore (prey) hypothesis, with forstrat:herb interaction, nlme Pagel
```
Generalized least squares fit by REML
  Model: oc ~ size + forstrat + herb + forstrat:herb
  Data: smallHerb_df
       AIC      BIC    logLik
  634.4219 651.2689 -310.2109

Correlation Structure: corPagel
 Formula: ~spp
 Parameter estimate(s):
   lambda
0.8998915

Coefficients:
                      Value Std.Error   t-value p-value
(Intercept)       30.500263  7.462911  4.086913  0.0001
size               1.184982  0.620111  1.910919  0.0595
forstratG         -1.059854  4.403500 -0.240684  0.8104
herbyes           -0.782783  3.578701 -0.218734  0.8274
forstratG:herbyes  5.362580  4.815429  1.113625  0.2687

 Correlation:
                  (Intr) size   frstrG herbys
size              -0.504
forstratG         -0.246 -0.173
herbyes           -0.301 -0.116  0.510
forstratG:herbyes  0.197  0.016 -0.713 -0.616

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.5858376 -0.4201713  0.5731727  1.3703349  3.8195779
Residual standard error: 15.63303
Degrees of freedom: 87 total; 82 residual
```

## Small herbivore (prey) hypothesis, with size:herb interaction, nlme BM
```
Generalized least squares fit by REML
  Model: oc ~ size + forstrat + herb + size:herb
  Data: smallHerb_df
       AIC      BIC    logLik
  652.2613 666.7016 -320.1307

Correlation Structure: corBrownian
 Formula: ~spp
 Parameter estimate(s):
numeric(0)

Coefficients:
                 Value Std.Error    t-value p-value
(Intercept)  30.751026 10.730912  2.8656488  0.0053
size          0.613690  0.870613  0.7048938  0.4829
forstratG     6.205015  2.952898  2.1013310  0.0387
herbyes      -7.767144  9.009479 -0.8621081  0.3911
size:herbyes  1.175915  1.042535  1.1279384  0.2626

 Correlation:
             (Intr) size   frstrG herbys
size         -0.577
forstratG    -0.096 -0.159
herbyes      -0.426  0.560  0.049
size:herbyes  0.404 -0.589 -0.026 -0.971

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.1947454 -0.3068635  0.3259240  1.0363944  2.5376029

Residual standard error: 22.62598
Degrees of freedom: 87 total; 82 residual
```

## Small herbivore (prey) hypothesis, with interaction, nlme Pagel
```
Generalized least squares fit by REML
  Model: oc ~ size + forstrat + herb + size:herb
  Data: smallHerb_df
       AIC      BIC    logLik
  638.8304 655.6774 -312.4152

Correlation Structure: corPagel
 Formula: ~spp
 Parameter estimate(s):
   lambda
0.8908557

Coefficients:
                 Value Std.Error  t-value p-value
(Intercept)  29.932073  8.582745 3.487471  0.0008
size          1.067322  0.849849 1.255896  0.2127
forstratG     2.160518  3.125688 0.691214  0.4914
herbyes       0.193546  8.173669 0.023679  0.9812
size:herbyes  0.175609  0.954671 0.183947  0.8545

 Correlation:
             (Intr) size   frstrG herbys
size         -0.683
forstratG    -0.141 -0.157
herbyes      -0.564  0.602  0.061
size:herbyes  0.528 -0.680 -0.018 -0.937

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.5256321 -0.4066070  0.4684321  1.3933085  3.9140272
Residual standard error: 15.5243
Degrees of freedom: 87 total; 82 residual
```

# Pagel's lambda models have significantly higher likelihood
```
[1] "res_preySize_BM vs res_preySize_P"
Likelihood ratio = 16.852(df=1) P = 4.041e-05
[1] "res_forstratHerbIntxn_BM vs res_forstratHerbIntxn_P"
Likelihood ratio = 16.498(df=1) P = 4.87e-05
[1] "res_sizeHerbIntxn_BM vs res_sizeHerbIntxn_P"
Likelihood ratio = 15.431(df=1) P = 8.557e-05
```

# Adding size as a covariate tends to improve models; adding an interaction between size and herbivory does not significantly improve the model
```
[1] "Size only vs foraging strategy w/ size as covariate:"
Likelihood ratio = 44.363(df=1) P = 2.728e-11
[1] "Foraging strategy only vs foraging strategy w/ size as covariate:"
Likelihood ratio = 4.8058(df=1) P = 0.02836
[1] "Foraging strategy only vs herbivory and foraging strategy w/ size as covariate:"
Likelihood ratio = 4.2294(df=1) P = 0.03973
[1] "herbivory and foraging strategy w/ size as covariate vs interaction between foraging strat and herb:"
Likelihood ratio = 6.1806(df=1) P = 0.01292
[1] "herbivory and foraging strategy w/ size as covariate vs interaction between size and herb:"
Likelihood ratio = 1.7721(df=1) P = 0.1831
```

# Conclusion: trend towards higher orbit convergence in arboreal species compared to ground foragers, but not significant