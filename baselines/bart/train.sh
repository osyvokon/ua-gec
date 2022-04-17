./prepare_data.py ../../data
./train.py \
    --model_name_or_path facebook/mbart-large-50 \
    --do_train \
    --do_eval \
    --source_lang src \
    --target_lang tgt \
    --mbart_source_lang uk_UA \
    --mbart_target_lang uk_UA \
    --max_source_length 64 \
    --max_target_length 64 \
    --val_max_target_length 100 \
    --fp16 \
    --optim adafactor \
    --train_file train.json \
    --validation_file valid.json \
    --output_dir output \
    --report_to wandb \
    --save_total_limit 5 \
    --save_steps 1000 \
    --per_device_train_batch_size=2 \
    --per_device_eval_batch_size=2 \
    --overwrite_output_dir \
    --predict_with_generate
