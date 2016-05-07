//
//  main.cpp
//  Sketch3D
//
//  Created by Xuaner Zhang on 4/13/16.
//  Copyright © 2016 Xuaner Zhang. All rights reserved.
//

#include <iostream>
#include <string.h>
#include <dirent.h>
#include "../../SketchRenderer.h"

using namespace std;

string imgpath = "/Users/ceciliazhang/Documents/Berkeley_PhD/Spring_2016/CS280/SketchBasedShapeRetrieval/data/training_shading/";
//string imgpath = "/Users/ceciliazhang/Documents/Berkeley_PhD/Spring_2016/CS280/SketchBasedShapeRetrieval/off/";

string path = "/Users/ceciliazhang/Documents/Berkeley_PhD/Spring_2016/CS280/SketchBasedShapeRetrieval/SHREC13_SBR_TARGET_MODELS/models/";

//string path = "/Users/ceciliazhang/Documents/Berkeley_PhD/Spring_2016/CS280/SketchBasedShapeRetrieval/off/";


void generateRender (const std::string& path) {
    
    DIR *dir;
    struct dirent *ent;
    std::string openpath, savename;
    std::string img = ".png";
    int i = 0;
    
    if ((dir = opendir (path.c_str())) != NULL) {
        /* print all the files and directories within directory */
        while ((ent = readdir (dir)) != NULL) {
            
            std::string subpath = std::string(ent->d_name);
            
            if(subpath == "." || subpath == "..")
                continue;
            if (int(ent->d_type) == 4) // a directory
            {
                generateRender( path + subpath + "/" );
                continue;
            }
            
            openpath = path + subpath;
            
            if (openpath.substr(openpath.length()-4, 4) != ".off")
                continue;
            
            SketchRenderer::load(openpath.c_str());
            cv::Mat1f shading = SketchRenderer::genShading(glm::vec3(1/2, 1/2, 0), glm::vec3(0, 1, 0));
//            cv::Mat sketch_vec = sketch.reshape;
            
//            viewMat[i][1:end] = sketch;
            i += 1;
            
            shading *= 255.;
            
            savename = imgpath + ent->d_name + img;
            
//            cv::namedWindow("sketch");
//            cv::imshow("sketch", sketch);
//            cv::waitKey(5);
            
            printf ("%s\n", savename.c_str());
            
            cv::imwrite( savename, shading );
            
            
        }
        
        closedir (dir);
    } else {
        /* could not open directory */
        perror ("");
        return;
    }
    
}


int main(int argc, const char * argv[]) {
    
//    std::string file = "/Users/ceciliazhang/Documents/Berkeley_PhD/Spring_2016/CS280/SketchBasedShapeRetrieval/SHREC13_SBR_Model.txt";
    
    std::vector<std::string> pathList;
    
    cv::Mat sketch_dst;
    
    SketchRenderer::init();
    generateRender( path );

    return 0;
}
