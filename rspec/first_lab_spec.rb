require 'rspec'
require_relative '../helpers/watir_helper'

RSpec.configure do |c|
  c.include Helpers
end

describe 'EPLAT' do

  before(:all) do
    browser('firefox')
  end

  it 'выполнен вход' do
    authentication('localhost', 'admin', 'P@ssw0rd')
    make_screenshot('выполнен вход')
  end

  it 'создано новое решение' do
    create_solution('Обработка заявок','тестовое решение')
    make_screenshot('создано новое решение')
  end

  it 'добавлено приложение Клиент' do
    add_application('Клиент')
    create_text_field('Название', 0)
    create_text_field('Директор', 1)
    create_text_field('Адрес', 2)
    create_text_field('Телефон/Факс', 3)
    create_text_field('E-mail', 4)
    set_name_for_link(0)
    make_screenshot('добавлено приложение Клиент')
    app_save_and_exit
  end

  it 'добавлено приложение Представители' do
    add_application('Представители')
    create_text_field('ФИО', 0)
    set_name_for_link(0)
    create_connection_field('Клиент', 1, 'Клиент', 'Многие к одному')
    create_text_field('Должность', 2)
    create_text_field('Контактный телефон', 3)
    make_screenshot('добавлено приложение Представители')
    app_save_and_exit
  end

  it 'добавлено приложение Проекты' do
    add_application('Проекты')
    create_text_field('Номер', 0)
    set_name_for_link(0)
    create_document_field('Договор', 1)
    create_connection_field('Клиент', 2, 'Клиент', 'Многие к одному')
    create_date_field('Дата начала', 3)
    create_date_field('Дата окончания', 4)
    create_connection_field('Представитель', 5, 'Представители', 'Многие к одному')
    create_connection_field('Менеджер', 6, 'Пользователи', 'Многие к одному')
    make_screenshot('добавлено приложение Проекты')
    app_save_and_exit
  end

  it 'добавлено приложение Заявки' do
    add_application('Заявки')
    create_text_field('Номер', 0)
    set_name_for_link(0)
    create_date_field('Дата регистрации', 1)
    set_сurrent_date(1)
    create_text_field('Описание', 2)
    create_connection_field('Инициатор', 3, 'Представители', 'Многие к одному')
    create_connection_field('Клиент', 4, 'Клиент', 'Многие к одному')
    create_connection_field('Проект', 5, 'Проекты', 'Многие к одному')
    create_connection_field('Исполнитель', 6, 'Пользователи', 'Многие к одному')
    create_date_field('Дата принятия в работу', 7)
    create_text_field('Работы по заявке', 8)
    create_date_field('Дата завершения работы', 9)
    make_screenshot('добавлено приложение Заявки')
    app_save_and_exit
  end

  it 'добавлен провайдер Заявки по времени' do
    add_provider('Заявки по проектам')
    add_app('Заявки')
    inset_change('Поля')
    choose_field(0, 'Идентификатор')
    select_func(0, 'Количество')
    choose_field(1, 'Дата регистрации')
    select_func(1, 'Группировка')
    make_screenshot('добавлен провайдер Заявки по времени')
    app_save_and_exit
  end

  it 'добавлен провайдер Заявки по клиентам' do
    add_provider('Заявки по клиентам')
    add_app('Заявки')
    bond_app(2)
    inset_change('Поля')
    choose_field(0, 'Идентификатор')
    select_func(0, 'Количество')
    choose_field(1, 'Название')
    select_func(1, 'Группировка')
    make_screenshot('добавлен провайдер Заявки по клиентам')
    app_save_and_exit
  end

  it 'добавлен провайдер Заявки по проектам' do
    add_provider('Заявки по клиентам')
    add_app('Заявки')
    bond_app(2)
    inset_change('Поля')
    choose_field(0, 'Идентификатор')
    select_func(0, 'Количество')
    choose_field(1, 'Номер')
    select_func(1, 'Группировка')
    make_screenshot('добавлен провайдер Заявки по клиентам')
    app_save_and_exit
  end

  it 'добавлена группа состояний' do
    inset_change('Администрирование')
    inset_change('Состояния')
    state_grout_set('Состояния заявки', 'Статусы заявок')
    make_screenshot('добавлена группа состояний')
    app_save_and_exit
  end

  it 'добавлено состояние Новая' do
    inset_change('Состояния')
    beg_state('Новая')
    make_screenshot('добавлено состояние Новая')
    app_save_and_exit
  end

  it 'добавлено состояние В работе' do
    inset_change('Состояния')
    new_state('В работе')
    make_screenshot('добавлено состояние В работе')
    app_save_and_exit
  end

  it 'добавлено состояние Выполнено' do
    inset_change('Состояния')
    new_state('Выполнено')
    make_screenshot('добавлено состояние Выполнено')
    app_save_and_exit
  end

  it 'добавлено состояние Закрыта' do
    inset_change('Состояния')
    new_state('Закрыта')
    make_screenshot('добавлено состояние Закрыта')
    app_save_and_exit
  end

  it 'настроены переходы между состояниями' do
    state_trans(0, 'В работе')
    inset_change('Состояния')
    state_trans(1, 'Выполнено')
    inset_change('Состояния')
    state_trans(2, 'В работе')
    inset_change('Состояния')
    state_trans(2, 'Закрыта') # =(
    make_screenshot('настроены переходы между состояниями')
  end

  it 'созданы роли' do
    inset_change('Безопасность')
    inset_change('Роли')
    add_role('Инженер СТП')
    add_role('Менеджер качества СТП')
    make_screenshot('созданы роли')
  end
  
end