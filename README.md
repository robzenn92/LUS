# LUS


There repo is structured as follows:

```
├───report
│   ├── Folder that contains the latex source code for the report
├── sequence\ labeling
│   ├──crf
│   │   ├── Source code for Conditional Random Fields
│   ├──fst
│   │   Source code for Finite State Transducer
└── text\ classification
	├── Source code for the text classification part using Naive Bayes
```

Each folder has:
- One or two files (written in BASH) for train and test the LM
- One file (written in BASH) for clean the folder from temp files.

Pay attention, execute only bash files which might call ruby files.

# FST

Below commands train and test a LM based on trigrams
sh clean.sh [optional]
sh test.sh
sh train.sh

# CRF++

Only one template has been stored in its folder. However, varius templates has been tested and results can be found in the report.

sh clean.sh [optional]
sh crf_train_and_test.sh

# TEXT CLASSIFICATION

The default configuration will train and test a LM based on Maximum Likelihood hypothesis.

sh clean.sh [optional]
sh setup.sh
sh test.rb