from minio_cli import MinioClient, BucketName


class Compiler:

    @staticmethod
    def compile(code_id, language) -> bool:
        print(f'receive message with code_id: {code_id}, language: {language}')

        """ read file from minio """
        zip_file = MinioClient.get_file(code_id, BucketName.Code.value)

        ''' compile '''  # todo Arshia
        file = None

        ''' write in minio '''
        MinioClient.upload(code_id, file, BucketName.Code.value)  # or new Bucket name
        return True
