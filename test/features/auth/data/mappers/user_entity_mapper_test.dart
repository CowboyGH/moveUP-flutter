import 'package:flutter_test/flutter_test.dart';
import 'package:moveup_flutter/features/auth/data/dto/user_dto.dart';
import 'package:moveup_flutter/features/auth/data/mappers/user_entity_mapper.dart';

void main() {
  group('UserEntityMapper.toEntity', () {
    test('maps dto to entity', () {
      final userDto = UserDto(
        id: 1,
        name: 'name',
        email: 'email',
        avatar: 'avatar',
        roleId: 1,
        emailVerifiedAt: 'emailVerifiedAt',
        updatedAt: 'updatedAt',
        createdAt: 'createdAt',
      );

      final userEntity = userDto.toEntity();

      expect(userEntity.id, 1);
      expect(userEntity.name, 'name');
      expect(userEntity.email, 'email');
      expect(userEntity.avatar, 'avatar');
    });

    test('maps dto to entity when avatar is null', () {
      final userDto = UserDto(
        id: 1,
        name: 'name',
        email: 'email',
        avatar: null,
        roleId: 1,
        emailVerifiedAt: 'emailVerifiedAt',
        updatedAt: 'updatedAt',
        createdAt: 'createdAt',
      );

      final userEntity = userDto.toEntity();

      expect(userEntity.id, 1);
      expect(userEntity.name, 'name');
      expect(userEntity.email, 'email');
      expect(userEntity.avatar, isNull);
    });
  });
}
