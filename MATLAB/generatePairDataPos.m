%% positive data pairs

sketchImg_s = load('sketchImg_test.mat');
sketchImg_s = sketchImg_s.sketchImg_test;
% sketchImg_s = sketchImg_test;
% sketchImg_s = uint8(sketchImg * 255);
% sketchImg_s(:,1) = uint8(sketchImg(:,1));

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

num_per_class = zeros(NUMCLASS,1);
for i = 1: NUMCLASS
    num_per_class(i) = length(find(viewImg_sc(:,1)==i));
end

num_view = size(viewImg3_s, 1);
num_sketch = size(sketchImg_s, 1);
IMGLENGTH = size(sketchImg_s, 2);
num_per_train = 1;

% each sketch image, 2 training, each training is a triplet
pairData = uint8(zeros(num_sketch*num_per_train, 4*(IMGLENGTH-1)+1));
pairData(:,1) = 1; % positive data
ii = 1;

pairData_label = uint8(zeros(num_sketch*num_per_train, 4));


%%
viewImg_s = viewImg_sc;

for i = 1:NUMCLASS
    i
%     rand_view = randi(3, 2, 1);
%     % make sure it's two different views
%     while(rand_view(1) == rand_view(2))
%         rand_view = randi(3, 2, 1);
%     end
%     
%     viewImg_s = viewImg_sc(num_view * (rand_view(1)-1)+1:num_view * (rand_view(1)),:);
%     viewImg_s = [viewImg_s; viewImg_sc(num_view * (rand_view(2)-1)+1:num_view * (rand_view(2)),:)];
%             
    sketch_class_ind = find(sketchImg_s(:,1)==i);
    num_sketch_class = length(sketch_class_ind);
    view_class_ind = find(viewImg_s(:,1) == i);
    num_view_class = length(view_class_ind);
    
    for j = 1:num_sketch_class
        
        cur_sketch_label = sketchImg_s(sketch_class_ind(j), 1);
        cur_sketch = sketchImg_s(sketch_class_ind(j), 2:end);
        
        sketch_pair_ind = sketch_class_ind(randi(num_sketch_class, 1, num_per_train));
%         while ismember(j, sketch_pair_ind) || length(unique(sketch_pair_ind))<length(sketch_pair_ind)
%             sketch_pair_ind = sketch_class_ind(randi(num_sketch_class, 1, num_per_train));
%         end
        
        sketch_view_ind = view_class_ind(randi(num_view_class, 1, num_per_train));
%         while length(unique(sketch_view_ind))<length(sketch_view_ind) ||...
%                 abs(sketch_view_ind(1)-sketch_view_ind(2))<=num_view
%             sketch_view_ind = view_class_ind(randi(num_view_class, 1, num_per_train));
%         end
        
        sketch_pair_view_ind = view_class_ind(randi(num_view_class, 1, num_per_train));
%         while (length(unique(sketch_pair_view_ind))<length(sketch_pair_view_ind) ||...
%                 abs(sketch_view_ind(1)-sketch_pair_view_ind(1))<=num_view ||...
%                 abs(sketch_view_ind(2)-sketch_pair_view_ind(2))<=num_view)
%             
%             sketch_pair_view_ind = view_class_ind(randi(num_view_class, 1, num_per_train));
%         end
        
        for k = 1:num_per_train
            pairData(ii+(k-1)*num_sketch, 2:end) = [cur_sketch,...
                sketchImg_s(sketch_pair_ind(k), 2:end),...
                viewImg_s(sketch_view_ind(k), 2:end),...
                viewImg_s(sketch_pair_view_ind(k), 2:end)];
            pairData_label(ii+(k-1)*num_sketch, 1) = cur_sketch_label;
            pairData_label(ii+(k-1)*num_sketch, 2) = sketchImg_s(sketch_pair_ind(k), 1);
            pairData_label(ii+(k-1)*num_sketch, 3) = viewImg_s(sketch_view_ind(k), 1);
            pairData_label(ii+(k-1)*num_sketch, 4) = viewImg_s(sketch_pair_view_ind(k), 1);
        end
        ii = ii+1;

    end
    
end



