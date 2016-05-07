%% For Traning dataset

train_label = train_all_pair(:,1);
sketch1 = train_all_pair(:,2:128*128+1);
sketch_pair = train_all_pair(:,128*128+2:2*128*128+1);
view1 = train_all_pair(:,2*128*128+2:3*128*128+1);
view_pair = train_all_pair(:,3*128*128+2:4*128*128+1);

delete('train.h5')

NUM_SAMPLE = 54000;
NUM_IMG = 128*128;

h5create('train.h5', '/label', [1,NUM_SAMPLE],'Datatype','uint8');
h5write('train.h5','/label',train_label');

h5create('train.h5', '/sketch', [NUM_IMG,NUM_SAMPLE],'Datatype','uint8');
h5write('train.h5','/sketch',sketch1');

h5create('train.h5', '/sketch_pair', [NUM_IMG,NUM_SAMPLE],'Datatype','uint8');
h5write('train.h5','/sketch_pair',sketch_pair');

h5create('train.h5', '/view', [NUM_IMG,NUM_SAMPLE],'Datatype','uint8');
h5write('train.h5','/view',view1');

h5create('train.h5', '/view_pair', [NUM_IMG,NUM_SAMPLE],'Datatype','uint8');
h5write('train.h5','/view_pair',view_pair');