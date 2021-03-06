#!/usr/bin/env bash

## Author: Evine Deng
## Source: https://github.com/EvineDeng/jd-base
## Modified： 2021-02-04
## Version： v3.9.0

## 路径
ShellDir=${JD_DIR:-$(cd $(dirname $0); pwd)}
[ ${JD_DIR} ] && HelpJd=jd || HelpJd=jd.sh
ScriptsDir=${ShellDir}/scripts
ConfigDir=${ShellDir}/config
FileConf=${ConfigDir}/config.sh
FileConfSample=${ShellDir}/sample/config.sh.sample
LogDir=${ShellDir}/log
ListScripts=($(cd ${ScriptsDir}; ls *.js | grep -E "j[drx]_"))
ListCron=${ConfigDir}/crontab.list

## 导入config.sh
function Import_Conf {
  if [ -f ${FileConf} ]
  then
    . ${FileConf}
    if [ -z "${Cookie1}" ]; then
      echo -e "请先在config.sh中配置好Cookie...\n"
      exit 1
    fi
  else
    echo -e "配置文件 ${FileConf} 不存在，请先按教程配置好该文件...\n"
    exit 1
  fi
}

## 更新crontab
function Detect_Cron {
  if [[ $(cat ${ListCron}) != $(crontab -l) ]]; then
    crontab ${ListCron}
  fi
}

## 用户数量UserSum
function Count_UserSum {
  for ((i=1; i<=1000; i++)); do
    Tmp=Cookie$i
    CookieTmp=${!Tmp}
    [[ ${CookieTmp} ]] && UserSum=$i || break
  done
}

## 组合Cookie和互助码子程序
function Combin_Sub {
  CombinAll=""
  for ((i=1; i<=${UserSum}; i++)); do
    for num in ${TempBlockCookie}; do
      if [[ $i -eq $num ]]; then
        continue 2
      fi
    done
    Tmp1=$1$i
    Tmp2=${!Tmp1}
    case $# in
      1)
        CombinAll="${CombinAll}&${Tmp2}"
        ;;
      2)
        CombinAll="${CombinAll}&${Tmp2}@$2"
        ;;
      3)
        if [ $(($i % 2)) -eq 1 ]; then
          CombinAll="${CombinAll}&${Tmp2}@$2"
        else
          CombinAll="${CombinAll}&${Tmp2}@$3"
        fi
        ;;
      4)
        case $(($i % 3)) in
          1)
            CombinAll="${CombinAll}&${Tmp2}@$2"
            ;;
          2)
            CombinAll="${CombinAll}&${Tmp2}@$3"
            ;;
          0)
            CombinAll="${CombinAll}&${Tmp2}@$4"
            ;;
        esac
        ;;
    esac
  done
  echo ${CombinAll} | perl -pe "{s|^&||; s|^@+||; s|&@|&|g; s|@+|@|g}"
}

## 组合Cookie、Token与互助码，用户自己的放在前面，我的放在后面
function Combin_All {
  export JD_COOKIE=$(Combin_Sub Cookie)
  export FRUITSHARECODES=$(Combin_Sub ForOtherFruit "64af0fffd7b3478585b2b71b377613ce@9fe344f3887243339369fd1f564ec49e@141be55835d4494fb06b0ac4e895ddef" "6d402dcfae1043fba7b519e0d6579a6f@5efc7fdbb8e0436f8694c4c393359576@6dc9461f662d490991a31b798f624128" "e2fd1311229146cc9507528d0b054da8@30f29addd75d44e88fb452bbfe9f2110@1d02fc9e0e574b4fa928e84cb1c5e70b")
  export PETSHARECODES=$(Combin_Sub ForOtherPet)
  export PLANT_BEAN_SHARECODES=$(Combin_Sub ForOtherBean "54i3jbri2l6fomplj6zedpwt4ifexs242jkgaai@4npkonnsy7xi2fqmflib7amovspi4y7hybdrapa@tnmcphpjys5icwjpxfmm3gwodgjirglqb6pnm4q@olmijoxgmjutzoaamsfbxewhiix3znzagvxr6ia" "mze7pstbax4l7dmo4vq6wz7vgu@rsuben7ys7sfbu5eub7knbibke@olmijoxgmjutzexyge246xwmaxy43t3jsqc74zy" "olmijoxgmjutybihibx67mwivxbag4rjviz3cji@m6mhupvfogvf5kuwe3c5h5fptd2syad6cznse4i@4npkonnsy7xi3mi4ngwtraxgzwabeyj7oky5rly")
  export DREAM_FACTORY_SHARE_CODES=$(Combin_Sub ForOtherDreamFactory "mEnEqVBBCQZ_Jt9dHXXAbQ==@7dAa1KpAimJEKUkwYZ5ovw==@g6XKy-b1PF1JLLRD7enX3w==@5AnP-NWntIbO2rEf58NCnA==" "CNt5BX1eD8Tw-Wq045YSWg==@phEELHGm3o7VKPIyiBO3Vw==@z-tDlNURI5HvM4MtehtjDA==@dzM8y-1G-D1pt6If32xQ0A==" "XCO7kpq00mMmYwOag2O_CQ==@48wAKDXkEE-RNwNs7W48MlW77AibIyB8QyD22ydJ4NI=@fzeFwj_aACkm-VgdmLqOhw==")
  export DDFACTORY_SHARECODES=$(Combin_Sub ForOtherJdFactory)
  export JDZZ_SHARECODES=$(Combin_Sub ForOtherJdzz)
  export JDJOY_SHARECODES=$(Combin_Sub ForOtherJoy)
  export JXNC_SHARECODES=$(Combin_Sub ForOtherJxnc)
  export JXNCTOKENS=$(Combin_Sub TokenJxnc)
  export BOOKSHOP_SHARECODES=$(Combin_Sub ForOtherBookShop "05d692a781834dc6815b90d440059d09@93c846eef3e8439ab0a655bc4c9b21e1@3113559ee4aa44469645507954dae9b4")
  export JD_CASH_SHARECODES=$(Combin_Sub ForOtherCash "Y0ppOLnsMf4v8G_Wy3s@eU9Ya73gMPwk82-EynFH1Q@eU9YC57TD7ZUkjKmsCVp@IRwwaei6bvkgnjM" "Vl1uMrmyZvs@eU9YarrjM_53p27dyXQa3g@9Jq0uXglsVCqKd5kEv-D@9YmhuUccv2W6J9VsHue5AQqJ" "eU9YarjhYqonpDrTzXcR1Q@eU9Ya77gZK5z-TqHn3UWhQ@eU9Yaui2ZP4gpG-Gz3EThA@eU9YaeizbvQnpG_SznIS0w")
  export JDNIAN_SHARECODES=$(Combin_Sub ForOtherNian "cgxZbzDccO-EvQzACQSq77eHJWUwT59lADSx2tLVDjfIsHShMTG4@cgxZdTXtI-uIvA7LCgT47mMhBoGH-yMR5KMmE3Xsh-aXP2l9a2YWtK2Noqs@cgxZdTXtQ8i7g0S7a1nalLAsu8xo_PbhblWR-kWcWD1tHGyGKxL4XA0@cgxZLWaFIb7S4gvPZ1jlo3Ru3_zhiy3nnTsS4mQaaZc" "cgxZWifbeu_a6gmFRGbg6Lh1SmQdF0DUmQ@cgxZdTXtIu6J7ljIXVGv6VoOs61gdyYXgT0ctAtCCykLsWw5accav11_0dI@cgxZ-fMU8RF0M5dV3r4QOsLKNQRnjyuoh9haQkLPPMH6fJjgVIkoZy5ww_K-I2JJ@cgxZ-OAB8S5NPaJF0LUYNl1oYE9tdRYPs2e2kWz3RrqEMgqutLWhZlw" "cgxZdTXtIuyLvwyYXgWh7YMhXtAVbaE0Ozjf2OUdEJZsvB1JgZ-5v5F_bDc@cgxZdTXtI-iI6FycAFH7u-1dMgurAZjyJ58rjmucS1-MNDQLuuFxg0MP4nk@cgxZdTXtIr7e6AzPXQT666v1QrNvBgZa6pzohEggDpwCCoJqAmI3w2yaU_s@cgxZdTXtIb7b4gbIXQSu6lqwwvtQXfo34CxB9K3ndzOzMDWK93LMQ85BnsQ")
  if [[ $(date -u "+%H") -eq 12 ]] || [[ $(date -u "+%H") -eq 13 ]]; then
    export JDNY_SHARECODES=$(Combin_Sub ForOtherNEWYEARMONEY "usNvD7MW94leAuMyN7g8s3c2i1OvK5YccxC_RiJ23Ip-6w@oMZeXLca9otVAeNgNrIk_GZu-8hHEOI3tbbj_g52x6MCo4S8@oMZePJQpycElYL5CTOYKswMDM5KxTKb4tqqe9VblYNI0TRY")
  else
    export JDNIANPK_SHARECODES=$(Combin_Sub ForOtherNianPk)
  fi
  export JDSXSY_SHARECODES=$(Combin_Sub ForOtherImmortal "23xIs4YwE5Z7HdgnUcxRT-XlSoXoJLmBE@56xIs4YwE5Z7G8-z3rXfTNliqVYXz9M6JRXG-yH8Vx4dLQzrizP4dLTPyH1_nW4EszjVqzvYCF7YE6CoNmvdjLBMjQ_@43xIs4YwE5Z7DsWOzDSP_d8Rjea5vaaX61gfhVs6SfEGnwcZB9wEJX2m2nHKOaC6Zjyw" "34xIs4YwE5Z7HhWvhuV0OSNsWxu4l5KyQo6VAKcMVw0BbhzvPXXg@43xIs4YwE5Z7DsWOzDSPOBTEaue3ty6EyxKwJhHK0IpkCccZB9wBAAi2jzGjO7Zk0NBQ@46xIs4YwE5Z7G9J6kzXVQUmik-F9Rd23gLTdzlTswGj7g5F1Q_VaEE-_9VqfmrrK7GkGwYKFc" "40xIs4YwE5Z7G9Wz1fXbiNaj7BIJ_cEtkCA14e3w3wC_EWRE9DEWJLOHy4bS9CN@43xIs4YwE5Z7DsWOzDSPPhRRrG8MhYR4xhrORXRDTIPqsocZB9wBIC2jyBAueqKUNS5w@28xIs4YwE5Z7HdgnUcxRT_3luPSlp4IXoJLmBFTjzk")
  export JDSGMH_SHARECODES=$(Combin_Sub ForOtherSgmh "T019_qwtFEtHolbeIRv3lP8CjVWmIaW5kRrbA@T0225KkcR09Lo1TVIhullfVedwCjVWmIaW5kRrbA@T0205KkcJ2x4nB6lQ0aH76FwCjVWmIaW5kRrbA" "T015vPp0RRoR_VHRT0cCjVWmIaW5kRrbA@T0225KkcRkpK8QLWdU7ykvMIdwCjVWmIaW5kRrbA@T024aG_llbW3LM1L9qFNQWOgo2QwCjVWmIaW5kRrbA" "T0225KkcRkhIoFaGdhr8lvADfACjVWmIaW5kRrbA@T011y7sqHksZ9VMCjVWmIaW5kRrbA@T020aXzwlYqOIvhb-KpFTXuaCjVWmIaW5kRrbA")
  export JSMOBILEFESTIVAL_SHARECODES=$(Combin_Sub ForOtherJdMobileFestival)
}

## 转换JD_BEAN_SIGN_STOP_NOTIFY或JD_BEAN_SIGN_NOTIFY_SIMPLE
function Trans_JD_BEAN_SIGN_NOTIFY {
  case ${NotifyBeanSign} in
    0)
      export JD_BEAN_SIGN_STOP_NOTIFY="true"
      ;;
    1)
      export JD_BEAN_SIGN_NOTIFY_SIMPLE="true"
      ;;
  esac
}

## 转换UN_SUBSCRIBES
function Trans_UN_SUBSCRIBES {
  export UN_SUBSCRIBES="${goodPageSize}\n${shopPageSize}\n${jdUnsubscribeStopGoods}\n${jdUnsubscribeStopShop}"
}

## 申明全部变量
function Set_Env {
  Count_UserSum
  Combin_All
  Trans_JD_BEAN_SIGN_NOTIFY
  Trans_UN_SUBSCRIBES
}

## 随机延迟
function Random_Delay {
  if [[ -n ${RandomDelay} ]] && [[ ${RandomDelay} -gt 0 ]]; then
    CurMin=$(date "+%-M")
    if [[ ${CurMin} -gt 2 && ${CurMin} -lt 30 ]] || [[ ${CurMin} -gt 31 && ${CurMin} -lt 59 ]]; then
      CurDelay=$((${RANDOM} % ${RandomDelay} + 1))
      echo -e "\n命令未添加 \"now\"，随机延迟 ${CurDelay} 秒后再执行任务，如需立即终止，请按 CTRL+C...\n"
      sleep ${CurDelay}
    fi
  fi
}

## 使用说明
function Help {
  echo -e "本脚本的用法为："
  echo -e "1. bash ${HelpJd} xxx      # 如果设置了随机延迟并且当时时间不在0-2、30-31、59分内，将随机延迟一定秒数"
  echo -e "2. bash ${HelpJd} xxx now  # 无论是否设置了随机延迟，均立即运行"
  echo -e "3. bash ${HelpJd} hangup   # 重启挂机程序"
  echo -e "4. bash ${HelpJd} resetpwd # 重置控制面板用户名和密码"
  echo -e "\n针对用法1、用法2中的\"xxx\"，无需输入后缀\".js\"，另外，如果前缀是\"jd_\"的话前缀也可以省略。"
  echo -e "当前有以下脚本可以运行（仅列出以jd_、jr_、jx_开头的脚本）："
  cd ${ScriptsDir}
  for ((i=0; i<${#ListScripts[*]}; i++)); do
    Name=$(grep "new Env" ${ListScripts[i]} | awk -F "'|\"" '{print $2}')
    echo -e "$(($i + 1)).${Name}：${ListScripts[i]}"
  done
}

## nohup
function Run_Nohup {
  for js in ${HangUpJs}
  do
    if [[ $(ps -ef | grep "${js}" | grep -v "grep") != "" ]]; then
      ps -ef | grep "${js}" | grep -v "grep" | awk '{print $2}' | xargs kill -9
    fi
  done

  for js in ${HangUpJs}
  do
    [ ! -d ${LogDir}/${js} ] && mkdir -p ${LogDir}/${js}
    LogTime=$(date "+%Y-%m-%d-%H-%M-%S")
    LogFile="${LogDir}/${js}/${LogTime}.log"
    nohup node ${js}.js > ${LogFile} &
  done
}

## pm2
function Run_Pm2 {
  pm2 flush
  for js in ${HangUpJs}
  do
    pm2 restart ${js}.js || pm2 start ${js}.js
  done
}

## 运行挂机脚本
function Run_HangUp {
  Import_Conf $1 && Detect_Cron && Set_Env
  HangUpJs="jd_crazy_joy_coin"
  cd ${ScriptsDir}
  if type pm2 >/dev/null 2>&1; then
    Run_Pm2 2>/dev/null
  else
    Run_Nohup >/dev/null 2>&1
  fi
}

## 重置密码
function Reset_Pwd {
  cp -f ${ShellDir}/sample/auth.json ${ConfigDir}/auth.json
  echo -e "控制面板重置成功，用户名：admin，密码：adminadmin\n"
}

## 运行京东脚本
function Run_Normal {
  Import_Conf $1 && Detect_Cron && Set_Env
  
  FileNameTmp1=$(echo $1 | perl -pe "s|\.js||")
  FileNameTmp2=$(echo $1 | perl -pe "{s|jd_||; s|\.js||; s|^|jd_|}")
  SeekDir="${ScriptsDir} ${ScriptsDir}/backUp ${ConfigDir}"
  FileName=""
  WhichDir=""

  for dir in ${SeekDir}
  do
    if [ -f ${dir}/${FileNameTmp1}.js ]; then
      FileName=${FileNameTmp1}
      WhichDir=${dir}
      break
    elif [ -f ${dir}/${FileNameTmp2}.js ]; then
      FileName=${FileNameTmp2}
      WhichDir=${dir}
      break
    fi
  done
  
  if [ -n "${FileName}" ] && [ -n "${WhichDir}" ]
  then
    [ $# -eq 1 ] && Random_Delay
    LogTime=$(date "+%Y-%m-%d-%H-%M-%S")
    LogFile="${LogDir}/${FileName}/${LogTime}.log"
    [ ! -d ${LogDir}/${FileName} ] && mkdir -p ${LogDir}/${FileName}
    cd ${WhichDir}
    node ${FileName}.js | tee ${LogFile}
  else
    echo -e "\n在${ScriptsDir}、${ScriptsDir}/backUp、${ConfigDir}三个目录下均未检测到 $1 脚本的存在，请确认...\n"
    Help
  fi
}

## 命令检测
case $# in
  0)
    echo
    Help
    ;;
  1)
    if [[ $1 == hangup ]]; then
      Run_HangUp
    elif [[ $1 == resetpwd ]]; then
      Reset_Pwd
    else
      Run_Normal $1
    fi
    ;;
  2)
    if [[ $2 == now ]]; then
      Run_Normal $1 $2
    else
      echo -e "\n命令输入错误...\n"
      Help
    fi
    ;;
  *)
    echo -e "\n命令过多...\n"
    Help
    ;;
esac
