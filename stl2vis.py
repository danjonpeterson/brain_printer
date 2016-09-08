'''
   stl2vis: creates a sequence of views of a surface
   usage: stl2vis filename.stl sampling_angle

   The image files then can be stiched in a gif file.
'''



# coding: utf-8
import sys
def main():

    from stl import mesh
    import numpy as np

    brainMesh = mesh.Mesh.from_file(sys.argv[1])

    # making the mesh smaller for testing
    #VERTICE_COUNT = 10000
    #data = np.zeros(VERTICE_COUNT, dtype=mesh.Mesh.dtype)
    #brainMesh = mesh.Mesh(data, remove_empty_areas=False)

    import matplotlib
    matplotlib.use("Qt4Agg")
    from mpl_toolkits import mplot3d
    import  matplotlib.pyplot as plt
    # get_ipython().magic('matplotlib notebook')
    # matplotlib.use("nbagg")


    figure = plt.figure()

    axes = mplot3d.Axes3D(figure)

    # Downscaling the data: otherwise it does not fit the plot
    axes.add_collection3d(mplot3d.art3d.Poly3DCollection(brainMesh.vectors/200,facecolors='gray',alpha=0.2))
    axes.relim()
    # axes.autoscale_view()
    # axes.autoscale()
    # axes.autoscale(enable=True,axis='both', tight=None)
    axes.set_xlim(np.min(brainMesh.vectors[:,:,0]/200),np.max(brainMesh.vectors[:,:,0]/200))
    axes.set_ylim(np.min(brainMesh.vectors[:,:,1]/200),np.max(brainMesh.vectors[:,:,1]/200))
    # axes.set_xlim(-1,1)
    # axes.set_ylim(-1,1)
    axes.axis('off')



    # plt.show()
    # plt.savefig('images/frame_front.png')



    if len(sys.argv)>2:
        sampling_angle = int(sys.argv[2])
    else:
        sampling_angle = 60

    for angle in range(0, 360, sampling_angle):
        axes.view_init(30, angle)
        plt.savefig('images/frame'+str(angle)+'.png')

if __name__=="__main__":
    main()
