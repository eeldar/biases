function [struct_out] = pseudorandomize_audio(number_of_trials, target_percentage)

in_times = [2.1,2.2,2.3,2.4,2.5,2.6,2.7,2.8,2.9];
in_times = in_times - .06;
min_sep = 3;

if nargin < 2
    target_percentage = .2;
end
if nargin < 1
    number_of_trials = 25;
end

num_targets = target_percentage*number_of_trials;
num_non_targets = (1-target_percentage)*number_of_trials;

%e.g. with number_of_trials = 15, target_percentage = .2 results:
%the calculation results in  15 - (2*4+1) = 6
%[0 0 0 0 0 0 1 0 0 0 1 0 0 0 1]
max_repetition_of_non_targets = number_of_trials-((min_sep+1)*(num_targets-1)+1);

%e.g. with above 15, .2 example the spots to fill are _1_1_1_
num_spots_to_fill =  num_targets + 1;

%following algorithm taken from stackoverflow.com/a/35074744
%initialize number of 0s array to minimum
num_zeros = min_sep*ones(num_spots_to_fill,1);
%preceding 0 does not have to exist
num_zeros(1) = 0;

while sum(num_zeros) < num_non_targets
    curr_sample = randsample(length(num_zeros),1);
    if num_zeros(curr_sample) < max_repetition_of_non_targets
        num_zeros(curr_sample) = num_zeros(curr_sample)+1;
    end
end

%generate our list of stimuli with this spacing
randomized_list = [];
for space_idx = 1:num_spots_to_fill
    randomized_list = [randomized_list; zeros(num_zeros(space_idx),1)];
    if space_idx < num_spots_to_fill
        randomized_list = [randomized_list; 1];
    end

spacing = datasample(in_times,number_of_trials,'Replace',true);

end

struct_out.randomized_list = randomized_list;
struct_out.spacing = spacing';

end