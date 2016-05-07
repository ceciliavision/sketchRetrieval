% T-SNE visualization
% with images plot on grids
%% tsne
feature_vec1 = load('../feature/feat_test_view.mat');
feature_vec2 = load('../feature/feat_test_sketch.mat');

feature_vec = [feature_vec2.feat_test_sketch(1:2700,:); feature_vec1.feat_test_view];

no_dims = 2;
initial_dims = 10;
perplexity = 30;

mappedX = tsne(feature_vec, [], no_dims, initial_dims, perplexity);

%% load embedding
% mappedX = tsne_feat_score_aug48;
%load('map_cifar.mat'); % load x (the embedding 2d locations from tsne)
mappedX = bsxfun(@minus, mappedX, min(mappedX));
mappedX = bsxfun(@rdivide, mappedX, max(mappedX));

%% create an embedding image
data_test_double = sketchImg_test_all;
sizea = 128;
sizeb = 128;

S = 10000; % size of full embedding image
G = zeros(S, S, 3, 'uint8');
s = 128; % size of every single image

Ntake = size(data_test_double, 1);
for i = 1:Ntake
    
    %if( label_test_double(i) ~= test_label_pred(i) )
        if mod(i, 100)==0
            fprintf('%d/%d...\n', i, Ntake);
        end
        
        % location
        a = ceil(mappedX(i, 1) * (S-s)+1);
        b = ceil(mappedX(i, 2) * (S-s)+1);
        a = a - mod(a-1,s)+1;
        b = b - mod(b-1,s)+1;
        if G(a,b,1) ~= 0
            continue % spot already filled
        end
        
        image = reshape ( data_test_double(i, 2:end), sizea, sizeb );
        if size(image,3)==1
            image = cat(3,image,image,image);
        end
        
        G(a:a+s-1, b:b+s-1, :) = uint8(image);
    %end
end

figure
imshow(G);

%imwrite(G, 'cnn_embed_2k.jpg', 'jpg');

%% do a guaranteed quade grid layout by taking nearest neighbor

S = 2000; % size of final image
G = zeros(S, S, 3, 'uint8');
s = 32; % size of every image thumbnail

xnum = S/s;
ynum = S/s;
used = false(Ntake, 1);

qq=length(1:s:S);
abes = zeros(qq*2,2);
i=1;
for a=1:s:S
    for b=1:s:S
        abes(i,:) = [a,b];
        i=i+1;
    end
end
%abes = abes(randperm(size(abes,1)),:); % randperm

for i=1:size(abes,1)
    a = abes(i,1);
    b = abes(i,2);
    %xf = ((a-1)/S - 0.5)/2 + 0.5; % zooming into middle a bit
    %yf = ((b-1)/S - 0.5)/2 + 0.5;
    xf = (a-1)/S;
    yf = (b-1)/S;
    dd = sum(bsxfun(@minus, mappedX, [xf, yf]).^2,2);
    dd(used) = inf; % dont pick these
    [dv,di] = min(dd); % find nearest image
    
    used(di) = true; % mark as done
    image = visualize_cifar ( data_test_double(i, :), sizea, sizeb );
    if size(image,3)==1
        image = cat(3,image,image,image);
    end
    image = imresize(image, [s, s]);
    
    G(a:a+s-1, b:b+s-1, :) = image;
    
    if mod(i,100)==0
        fprintf('%d/%d\n', i, size(abes,1));
    end
end

imshow(G);

% imwrite(G, 'cnn_embed_full_2k.jpg', 'jpg');
