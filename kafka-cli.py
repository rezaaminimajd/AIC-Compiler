import enum
from compiler import Compiler
from kafka import KafkaConsumer
import json
import time


class Topics(enum.Enum):
    STORE_CODE = "store-code"


maximum_try_count = 10

consumer = KafkaConsumer(
    Topics.STORE_CODE.value,
    bootstrap_servers='185.204.197.207:9092',
    group_id=None,
    auto_offset_reset='earliest'
)

for message in consumer:
    data = json.loads(message.value.decode("utf-8"))
    result = Compiler.compile(code_id=data['code_id'], language=data['language'])
    # if result:
    #     consumer.commit()
    # else:
    #     try_count = 0
    #     while not Compiler.compile(code_id=data['code_id'],
    #                                language=data['language']) and try_count < maximum_try_count:
    #         try_count += 1
    #         time.sleep(try_count)
    #     consumer.commit()
