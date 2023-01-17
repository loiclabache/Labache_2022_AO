import matplotlib as mpl
import matplotlib.pyplot as plt
from nilearn import plotting
import numpy as np
import glob as gb

from brainspace.gradient import GradientMaps

# mpl.use('TkAgg')

average_matrix = np.genfromtxt(
    '/Data/averageData/groupLevel_correlationMatrix.txt',
    delimiter='\t')
np.fill_diagonal(average_matrix, 0)
# print(average_matrix)
# print(type(average_matrix))

# corr_plot = plotting.plot_matrix(average_matrix, figure=(100, 100), vmax=1, vmin=-1)
# print(corr_plot)
# plt.show()

# https://brainspace.readthedocs.io/en/latest/python_doc/auto_examples/plot_tutorial2.html
# https://brainspace.readthedocs.io/en/latest/generated/brainspace.gradient.gradient.GradientMaps.html#brainspace.gradient.gradient.GradientMaps
gm = GradientMaps(kernel='normalized_angle', approach='dm', n_components=10, random_state=0)

grad_m = gm.fit(average_matrix, sparsity=0.9)
np.savetxt("/Data/groupLevel_gradient.csv", grad_m.gradients_[:, [0, 1, 2]], delimiter=',')

path_matrices = gb.glob("/correlationMatrix_Individual/*.csv")

for s in range(len(path_matrices)):
    print(s)
    individual_matrix = np.genfromtxt(path_matrices[s], delimiter=',', skip_header=1)
    individual_matrix = np.delete(individual_matrix, 0, 1)
    np.fill_diagonal(individual_matrix, 0)
    # # #
    gm_sujet = GradientMaps(kernel='normalized_angle', approach='dm', n_components=10, random_state=0, alignment='procrustes')
    # # #
    chemin = path_matrices[s].replace('correlationMatrix_Individual/', '')
    chemin = chemin.replace('_correlationMatrix_AICHA_4scansAverage.csv', '')
    # # #
    grad_individual = gm_sujet.fit([average_matrix, individual_matrix], sparsity=0.9)
    np.savetxt((chemin + '_gradient_aligned.csv'), grad_individual.aligned_[1][:, [0, 1, 2]], delimiter=',')
