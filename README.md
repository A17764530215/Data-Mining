# Data-Mining
All data mining practice with Matlab

Code for paper: [Multi-task least squares twin support vector machine for classification](https://www.sciencedirect.com/science/article/pii/S0925231219302061)

## Single-task learning
* SVM: Support vector machine
* LSSVM: Least squares support vector machine
* PSVM: Proximal support vector machine
* TWSVM: Twin support vector machine
* LS-TWSVM: Least squares twin support vector machine
* $\nu$-TWSVM: $\nu$-Twin support vector machine
## Multi-task learning
* RMTL: Regularized multi-task learning
* MTLS-SVM: Multi-task least squares support vector machine
* MTPSVM: Multi-tasl proximal support vector machine
* MT-aLS-SVM: Multi-task asymmetric least squares support vector machine
* DMTSVM: Multi-task twin support vector machine
* MTCTSVM: Multi-task centroid twin support vector machine
* MTLS-TWSVM: Multi-task least squares twin support vector machine

## Bibtex:
@article{MEI2019,
  title = "Multi-task least squares twin support vector machine for classification",
  journal = "Neurocomputing",
  year = "2019",
  issn = "0925-2312",
  doi = "https://doi.org/10.1016/j.neucom.2018.12.079",
  url = "http://www.sciencedirect.com/science/article/pii/S0925231219302061",
  author = "Benshan Mei and Yitian Xu",
  keywords = "Pattern recognition, Multi-task learning, Relation learning, Least square twin support vector machine",
  abstract = "With the bloom of machine learning, pattern recognition plays an important role in many aspects. However, traditional pattern recognition mainly focuses on single task learning (STL), and the multi-task learning (MTL) has largely been ignored. Compared to STL, MTL can improve the performance of learning methods through the shared information among all tasks. Inspired by the recently proposed directed multi-task twin support vector machine (DMTSVM) and the least squares twin support vector machine (LSTWSVM), we put forward a novel multi-task least squares twin support vector machine (MTLS-TWSVM). Instead of two dual quadratic programming problems (QPPs) solved in DMTSVM, our algorithm only needs to deal with two smaller linear equations. This leads to simple solutions, and the calculation can be effectively accelerated. Thus, our proposed model can be applied to the large scale datasets. In addition, it can deal with linear inseparable samples by using kernel trick. Experiments on three popular multi-task datasets show the effectiveness of our proposed methods. Finally, we apply it to two popular image datasets, and the experimental results also demonstrate the validity of our proposed algorithm."
}
