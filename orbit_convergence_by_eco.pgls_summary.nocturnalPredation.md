# Based on both Brownian motion and Pagel's lambda models, orbit convergence is not associated with predation
## Predator hypothesis, nlme BM
```
Generalized least squares fit by REML
  Model: oc ~ pred
  Data: noctPred_df
       AIC      BIC    logLik
  699.8572 707.3231 -346.9286

Correlation Structure: corBrownian
 Formula: ~spp
 Parameter estimate(s):
numeric(0)

Coefficients:
               Value Std.Error   t-value p-value
(Intercept) 40.09973  9.248702  4.335715  0.0000
predyes     -1.02269  4.691116 -0.218006  0.8279

 Correlation:
        (Intr)
predyes -0.108

Standardized residuals:
       Min         Q1        Med         Q3        Max
-0.8067389 -0.2175642  0.3475954  0.8931085  2.7132582

Residual standard error: 24.91479
Degrees of freedom: 91 total; 89 residual
```
## Predator hypothesis, nlme Pagel:
```
Generalized least squares fit by REML
  Model: oc ~ pred
  Data: noctPred_df
       AIC      BIC    logLik
  682.4059 692.3604 -337.2029

Correlation Structure: corPagel
 Formula: ~spp
 Parameter estimate(s):
   lambda
0.8387313

Coefficients:
               Value Std.Error   t-value p-value
(Intercept) 40.55063  5.424694  7.475192  0.0000
predyes     -1.14833  3.759187 -0.305474  0.7607

 Correlation:
        (Intr)
predyes -0.147

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.3261427 -0.3788886  0.5297546  1.4108649  4.3331824

Residual standard error: 15.49655
Degrees of freedom: 91 total; 89 residual
```

# Add size as covariate - still no significant association with predation with either phylogenetic model
## "Predator hypothesis, with size as covariate, nlme BM:"
```
Generalized least squares fit by REML
  Model: oc ~ size + pred
  Data: noctPred_df
      AIC      BIC   logLik
  697.384 707.2934 -344.692

Correlation Structure: corBrownian
 Formula: ~spp
 Parameter estimate(s):
numeric(0)

Coefficients:
                Value Std.Error    t-value p-value
(Intercept) 30.937821 10.432257  2.9655923  0.0039
size         1.322731  0.728291  1.8162135  0.0727
predyes     -1.742208  4.648597 -0.3747816  0.7087

 Correlation:
        (Intr) size
size    -0.484
predyes -0.053 -0.085

Standardized residuals:
       Min         Q1        Med         Q3        Max
-0.9431008 -0.2358832  0.3160876  0.7701745  2.4866790

Residual standard error: 24.59915
Degrees of freedom: 91 total; 88 residual
#"Predator hypothesis, with size as covariate, nlme Pagel:"
Generalized least squares fit by REML
  Model: oc ~ size + pred
  Data: noctPred_df
       AIC      BIC    logLik
  680.5965 692.9832 -335.2983

Correlation Structure: corPagel
 Formula: ~spp
 Parameter estimate(s):
   lambda
0.8469741

Coefficients:
               Value Std.Error   t-value p-value
(Intercept) 32.91079  6.986289  4.710768  0.0000
size         1.05138  0.605958  1.735075  0.0862
predyes     -1.36503  3.727671 -0.366189  0.7151

 Correlation:
        (Intr) size
size    -0.628
predyes -0.093 -0.032

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.4363189 -0.3779520  0.5127083  1.2449401  4.0303206

Residual standard error: 15.4816
Degrees of freedom: 91 total; 88 residual
```

# Orbit convergence is not associated with activity pattern, regardless of phylogenetic model and regardless of whether or not size is considered as a covariate
## Nocturnal hypothesis, nlme BM
```
Generalized least squares fit by REML
  Model: oc ~ activity
  Data: noctPred_df
       AIC      BIC    logLik
  699.4818 709.3911 -345.7409

Correlation Structure: corBrownian
 Formula: ~spp
 Parameter estimate(s):
numeric(0)

Coefficients:
                 Value Std.Error   t-value p-value
(Intercept)   39.63028  9.288086  4.266786  0.0000
activitylight  1.09570  2.786908  0.393159  0.6952
activitymix   -0.45405  2.219755 -0.204549  0.8384

 Correlation:
              (Intr) actvtyl
activitylight -0.110
activitymix   -0.088  0.560

Standardized residuals:
       Min         Q1        Med         Q3        Max
-0.7851054 -0.2173431  0.3167462  0.8748431  2.6786002

Residual standard error: 25.00337
Degrees of freedom: 91 total; 88 residual

         Simultaneous Tests for General Linear Hypotheses

Multiple Comparisons of Means: Tukey Contrasts


Fit: gls(model = oc ~ activity, data = noctPred_df, correlation = corBM)

Linear Hypotheses:
                  Estimate Std. Error z value Pr(>|z|)
light - dark == 0    1.096      2.787   0.393    0.917
mix - dark == 0     -0.454      2.220  -0.205    0.977
mix - light == 0    -1.550      2.400  -0.646    0.793
(Adjusted p values reported -- single-step method)
```

## "Nocturnal hypothesis, nlme Pagel:"
```
Generalized least squares fit by REML
  Model: oc ~ activity
  Data: noctPred_df
       AIC     BIC    logLik
  680.0184 692.405 -335.0092

Correlation Structure: corPagel
 Formula: ~spp
 Parameter estimate(s):
   lambda
0.8318001

Coefficients:
                 Value Std.Error   t-value p-value
(Intercept)   40.64314  5.411264  7.510841  0.0000
activitylight  0.47445  2.802580  0.169289  0.8660
activitymix   -2.66586  2.846789 -0.936444  0.3516

 Correlation:
              (Intr) actvtyl
activitylight -0.192
activitymix   -0.163  0.510

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.3456892 -0.3797814  0.5034298  1.4073990  4.3403867

Residual standard error: 15.3402
Degrees of freedom: 91 total; 88 residual

         Simultaneous Tests for General Linear Hypotheses

Multiple Comparisons of Means: Tukey Contrasts


Fit: gls(model = oc ~ activity, data = noctPred_df, correlation = corPagel)

Linear Hypotheses:
                  Estimate Std. Error z value Pr(>|z|)
light - dark == 0   0.4744     2.8026   0.169    0.984
mix - dark == 0    -2.6659     2.8468  -0.936    0.617
mix - light == 0   -3.1403     2.7979  -1.122    0.500
(Adjusted p values reported -- single-step method)
```

## "Nocturnal hypothesis, with size as covariate, nlme BM:"
```
Generalized least squares fit by REML
  Model: oc ~ size + activity
  Data: noctPred_df
       AIC      BIC    logLik
  697.1831 709.5126 -343.5915

Correlation Structure: corBrownian
 Formula: ~spp
 Parameter estimate(s):
numeric(0)

Coefficients:
                  Value Std.Error    t-value p-value
(Intercept)   30.726629 10.476928  2.9327899  0.0043
size           1.291941  0.732943  1.7626753  0.0815
activitylight  0.593662  2.768819  0.2144098  0.8307
activitymix   -0.746608  2.199919 -0.3393797  0.7351

 Correlation:
              (Intr) size   actvtyl
size          -0.482
activitylight -0.046 -0.103
activitymix   -0.040 -0.075  0.564

Standardized residuals:
       Min         Q1        Med         Q3        Max
-0.8866514 -0.2342254  0.2511615  0.7677367  2.4748036

Residual standard error: 24.7093
Degrees of freedom: 91 total; 87 residual

         Simultaneous Tests for General Linear Hypotheses

Multiple Comparisons of Means: Tukey Contrasts


Fit: gls(model = oc ~ size + activity, data = noctPred_df, correlation = corBM)

Linear Hypotheses:
                  Estimate Std. Error z value Pr(>|z|)
light - dark == 0   0.5937     2.7688   0.214    0.975
mix - dark == 0    -0.7466     2.1999  -0.339    0.938
mix - light == 0   -1.3403     2.3749  -0.564    0.837
```

## Nocturnal hypothesis, with size as covariate, nlme Pagel:
```
Generalized least squares fit by REML
  Model: oc ~ size + activity
  Data: noctPred_df
       AIC      BIC   logLik
  678.2841 693.0795 -333.142

Correlation Structure: corPagel
 Formula: ~spp
 Parameter estimate(s):
   lambda
0.8389264

Coefficients:
                 Value Std.Error   t-value p-value
(Intercept)   33.27994  6.910919  4.815559  0.0000
size           1.04030  0.608730  1.708969  0.0910
activitylight -0.21554  2.798164 -0.077028  0.9388
activitymix   -2.98597  2.816272 -1.060255  0.2920

 Correlation:
              (Intr) size   actvtyl
size          -0.622
activitylight -0.061 -0.139
activitymix   -0.084 -0.067  0.516

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.3737284 -0.4067482  0.4901774  1.2815082  4.0754613

Residual standard error: 15.30448
Degrees of freedom: 91 total; 87 residual

         Simultaneous Tests for General Linear Hypotheses

Multiple Comparisons of Means: Tukey Contrasts


Fit: gls(model = oc ~ size + activity, data = noctPred_df, correlation = corPagel)

Linear Hypotheses:
                  Estimate Std. Error z value Pr(>|z|)
light - dark == 0  -0.2155     2.7982  -0.077    0.997
mix - dark == 0    -2.9860     2.8163  -1.060    0.539
mix - light == 0   -2.7704     2.7626  -1.003    0.575
(Adjusted p values reported -- single-step method)
```

# No support for the nocturnal predation hypothesis (no significant interaction between activity pattern and predation)
## Nocturnal predation hypothesis, nlme BM

```
Generalized least squares fit by REML
  Model: oc ~ pred + activity + pred:activity
  Data: noctPred_df
       AIC      BIC    logLik
  690.2634 707.3619 -338.1317

Correlation Structure: corBrownian
 Formula: ~spp
 Parameter estimate(s):
numeric(0)

Coefficients:
                         Value Std.Error   t-value p-value
(Intercept)           39.95490  9.591602  4.165612  0.0001
predyes               -1.14685  5.027986 -0.228093  0.8201
activitylight          0.44071  4.348325  0.101351  0.9195
activitymix           -0.58275  4.822099 -0.120850  0.9041
predyes:activitylight  1.51211  5.919067  0.255465  0.7990
predyes:activitymix    0.30687  5.432468  0.056488  0.9551

 Correlation:
                      (Intr) predys actvtyl actvtym prdys:ctvtyl
predyes               -0.134
activitylight         -0.165  0.166
activitymix           -0.160  0.185  0.689
predyes:activitylight  0.106 -0.237 -0.726  -0.493
predyes:activitymix    0.143 -0.272 -0.610  -0.881   0.602

Standardized residuals:
       Min         Q1        Med         Q3        Max
-0.7849126 -0.2047238  0.2987482  0.8733950  2.6473735

Residual standard error: 25.42308
Degrees of freedom: 91 total; 85 residual
```

## Nocturnal predation hypothesis, nlme Pagel
```
Generalized least squares fit by REML
  Model: oc ~ pred + activity + pred:activity
  Data: noctPred_df
       AIC      BIC    logLik
  670.6943 690.2355 -327.3471

Correlation Structure: corPagel
 Formula: ~spp
 Parameter estimate(s):
   lambda
0.8229225

Coefficients:
                         Value Std.Error   t-value p-value
(Intercept)           40.47099  5.524306  7.325986  0.0000
predyes                0.29225  4.343509  0.067284  0.9465
activitylight          1.68680  3.429466  0.491854  0.6241
activitymix           -1.94886  3.968164 -0.491124  0.6246
predyes:activitylight -3.66724  6.112501 -0.599958  0.5501
predyes:activitymix   -1.99411  5.715553 -0.348891  0.7280

 Correlation:
                      (Intr) predys actvtyl actvtym prdys:ctvtyl
predyes               -0.181
activitylight         -0.209  0.186
activitymix           -0.199  0.199  0.465
predyes:activitylight  0.095 -0.386 -0.554  -0.233
predyes:activitymix    0.142 -0.441 -0.326  -0.665   0.525

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.3278886 -0.4404063  0.5760003  1.3498820  4.2515172

Residual standard error: 15.41619
Degrees of freedom: 91 total; 85 residual
```

## Nocturnal predation hypothesis, with size as covariate, nlme BM
```
Generalized least squares fit by REML
  Model: oc ~ size + pred + activity + pred:activity
  Data: noctPred_df
       AIC      BIC    logLik
  687.6853 707.1318 -335.8426

Correlation Structure: corBrownian
 Formula: ~spp
 Parameter estimate(s):
numeric(0)

Coefficients:
                          Value Std.Error    t-value p-value
(Intercept)           30.701892 10.734972  2.8599880  0.0053
size                   1.379421  0.755713  1.8253238  0.0715
predyes               -2.015410  4.983177 -0.4044429  0.6869
activitylight         -0.731860  4.337711 -0.1687202  0.8664
activitymix           -0.964817  4.761889 -0.2026122  0.8399
predyes:activitylight  3.002499  5.896319  0.5092158  0.6119
predyes:activitymix    0.523283  5.360764  0.0976134  0.9225

 Correlation:
                      (Intr) size   predys actvtyl actvtym prdys:ctvtyl
size                  -0.472
predyes               -0.073 -0.095
activitylight         -0.074 -0.148  0.177
activitymix           -0.120 -0.044  0.189  0.688
predyes:activitylight  0.027  0.138 -0.247 -0.731  -0.494
predyes:activitymix    0.116  0.022 -0.273 -0.606  -0.881   0.599

Standardized residuals:
       Min         Q1        Med         Q3        Max
-0.9015493 -0.2399394  0.2800058  0.7747863  2.4508118

Residual standard error: 25.08138
Degrees of freedom: 91 total; 84 residual
```

## Nocturnal predation hypothesis, with size as covariate, nlme Pagel
```
Generalized least squares fit by REML
  Model: oc ~ size + pred + activity + pred:activity
  Data: noctPred_df
       AIC     BIC    logLik
  669.1886 691.066 -325.5943

Correlation Structure: corPagel
 Formula: ~spp
 Parameter estimate(s):
   lambda
0.8351459

Coefficients:
                         Value Std.Error   t-value p-value
(Intercept)           33.25907  7.125153  4.667840  0.0000
size                   1.02912  0.636153  1.617728  0.1095
predyes               -0.21158  4.311730 -0.049070  0.9610
activitylight          0.33906  3.493474  0.097055  0.9229
activitymix           -2.04521  3.937088 -0.519473  0.6048
predyes:activitylight -1.46621  6.157411 -0.238122  0.8124
predyes:activitymix   -1.94143  5.639001 -0.344287  0.7315

 Correlation:
                      (Intr) size   predys actvtyl actvtym prdys:ctvtyl
size                  -0.623
predyes               -0.098 -0.066
activitylight         -0.018 -0.224  0.194
activitymix           -0.141 -0.020  0.199  0.464
predyes:activitylight -0.055  0.204 -0.387 -0.578  -0.237
predyes:activitymix    0.107  0.005 -0.437 -0.324  -0.669   0.517
Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.3506503 -0.3948706  0.5008074  1.2542147  4.0009778

Residual standard error: 15.48893
Degrees of freedom: 91 total; 84 residual
```