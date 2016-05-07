%% positive data pairs

% sketchImg = load('sketchImg.mat');
% sketchImg = sketchImg.sketchImg;
% viewImg1 = load('viewImg1.mat');
% viewImg2 = load('viewImg2.mat');
% viewImg3 = load('viewImg3.mat');
% viewImg = [viewImg1.viewImg1;viewImg2.viewImg2;viewImg3.viewImg3];

% function pairDataNeg = generatePairDataNeg (viewImg, sketchImg, num_per_train, filename)
load('sketchImg_test.mat')
sketchImg = sketchImg_test;

viewImg1 = load('viewImg1.mat');
viewImg1_s = uint8(viewImg1.viewImg1 * 255);
viewImg1_s(:,1) = viewImg1.viewImg1(:,1);

viewImg2 = load('viewImg2.mat');
viewImg2_s = uint8(viewImg2.viewImg2 * 255);
viewImg2_s(:,1) = viewImg2.viewImg2(:,1);

viewImg3 = load('viewImg3.mat');
viewImg3_s = uint8(viewImg3.viewImg3 * 255);
viewImg3_s(:,1) = viewImg3.viewImg3(:,1);

viewImg = [viewImg1.viewImg1;viewImg2.viewImg2;viewImg3.viewImg3];
NUMCLASS = 90;
viewImg_sc = uint8(viewImg * 255);
viewImg_sc(:,1) = viewImg(:,1);

num_sketch = size(sketchImg, 1);
num_view = size(viewImg, 1);
IMGLENGTH = size(sketchImg, 2);

% num_per_train = 2;
% each sketch image, 2 training, each training is a triplet
pairDataNeg = uint8(zeros(num_sketch*num_per_train, 4*(IMGLENGTH-1)+1));
pairDataNeg(:,1) = 0; % negative data
ii = 1;

sketch_class_zero = find(sketchImg(:,1)==0);
sketchRange = 1:num_sketch;
sketchRange(sketch_class_zero) = [];
viewRange = 1:num_view;
view_class_ind_pos0 = find( viewImg(:,1) == 0 );
% viewRange(view_class_zero) = [];

num_per_train = 1;

pairDataNeg_label = uint8(zeros(num_sketch*num_per_train, 4));

%%
viewImg = viewImg_sc;


for i = 1:NUMCLASS
    
    i
    
    sketch_class_ind_pos = find(sketchImg(sketchRange,1)==i);
    sketch_class_ind_neg = sketchRange;
    sketch_class_ind_neg(sketchRange(sketch_class_ind_pos))=[];
    num_sketch_class_neg = length(sketch_class_ind_neg);
    num_sketch_class_pos = length(sketch_class_ind_pos);
    
    view_class_ind_pos = find( viewImg(:,1) == i );
    
    view_class_ind_neg = viewRange;
    view_class_ind_neg( union(view_class_ind_pos, view_class_ind_pos0) )=[];
    num_view_class_pos = length(view_class_ind_pos);
    num_view_class_neg = length(view_class_ind_neg);
    
    for j = 1:num_sketch_class_pos
        
        cur_sketch_label = sketchImg(sketch_class_ind_pos(j), 1);
        cur_sketch = sketchImg(sketch_class_ind_pos(j), 2:end);
        
        sketch_pair_ind = sketch_class_ind_neg(randi(num_sketch_class_neg, 1, num_per_train));
        %         while ismember(j, sketch_pair_ind) || length(unique(sketch_pair_ind))<length(sketch_pair_ind)
        %             sketch_pair_ind = sketch_class_ind_neg(randi(num_sketch_class, 1, num_per_train));
        %         end
        
        sketch_view_ind = view_class_ind_neg(randi(num_view_class_neg, 1, num_per_train));
        %         while length(unique(sketch_view_ind))<length(sketch_view_ind)
        %             sketch_view_ind = view_class_ind_neg(randi(num_view_class_neg, 1, num_per_train));
        %         end
        
        sketch_pair_view_ind = view_class_ind_neg(randi(num_view_class_neg, 1, num_per_train));
        %         while length(unique(sketch_pair_view_ind))<length(sketch_pair_view_ind)
        %             sketch_pair_view_ind = view_class_ind_neg(randi(num_view_class_neg, 1, num_per_train));
        %         end
        
        for k = 1:num_per_train
            pairDataNeg(ii+(k-1)*num_sketch, 2:end) = [cur_sketch,...
                sketchImg(sketch_pair_ind(k), 2:end),...
                viewImg(sketch_view_ind(k), 2:end),...
                viewImg(sketch_pair_view_ind(k), 2:end)];
            pairDataNeg_label(ii+(k-1)*num_sketch, 1) = cur_sketch_label;
            pairDataNeg_label(ii+(k-1)*num_sketch, 2) = sketchImg(sketch_pair_ind(k), 1);
            pairDataNeg_label(ii+(k-1)*num_sketch, 3) = viewImg(sketch_view_ind(k), 1);
            pairDataNeg_label(ii+(k-1)*num_sketch, 4) = viewImg(sketch_pair_view_ind(k), 1);
        end
        ii = ii+1;
        
    end
    
end

% save(filename, 'pairDataNeg', '-v7.3');

% end
