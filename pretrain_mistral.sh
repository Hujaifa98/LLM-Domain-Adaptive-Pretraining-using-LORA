# pip3 install -r requirements.txt

echo ===== PRETRAINING =====
# Node that MODEL_PATH can be local folder path
MODEL_PATH=mistralai/Mixtral-8x22B-Instruct-v0.1
TITLE=mistral-7b-v0.1-pretrain
DATA=data

OUTPUT_DIR=result
mkdir $OUTPUT_DIR

echo ===== current OUTPUT_DIR is $OUTPUT_DIR =====
echo ===== MODEL_PATH is $MODEL_PATH =====

torchrun --nproc_per_node=2 --master_port=9919 pretrain_org.py \
    --model_name_or_path $MODEL_PATH \
    --data_path $DATA \
    --bf16 True \
    --output_dir $OUTPUT_DIR \
    --num_train_epochs 5 \
    --per_device_train_batch_size 1 \
    --per_device_eval_batch_size 1 \
    --gradient_accumulation_steps 1 \
    --evaluation_strategy "no" \
    --save_strategy "epoch" \
    --logging_steps 50 \
    --save_steps 100 \
    --save_total_limit 1 \
    --learning_rate 1e-5 \
    --weight_decay 0. \
    --warmup_ratio 0.03 \
    --lr_scheduler_type "cosine" \
    --logging_steps 1 \
    --fsdp "full_shard auto_wrap" \
    --fsdp_transformer_layer_cls_to_wrap 'MistralDecoderLayer' \
    --tf32 False \
