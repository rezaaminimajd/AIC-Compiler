from minio_cli import MinioClient, BucketName


class Compiler:

    @staticmethod
    def compile(code_id, language) -> bool:
        print(f'receive message with code_id: {code_id}, language: {language}')

        """ read file from minio """
        zip_file = MinioClient.get_file(code_id, BucketName.Code.value)
        with open('code.zip', 'wb') as f:
            f.write(zip_file)

        ''' compile '''  # todo Arshia
        f = open('compiled.zip', 'r')
        file = f.read()
        f.close()

        ''' write in minio '''
        MinioClient.upload(code_id, file, BucketName.Code.value)
        return True
